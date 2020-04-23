defmodule BankApi.Controllers.User do
  @moduledoc """
    User Controller context
  """
  use Plug.Router
  alias BankApi.Repo
  alias BankApi.Helpers.TranslateError
  alias BankApi.Models.Customers
  alias BankApi.Models.Transactions
  alias BankApi.Router
  alias BankApi.Auth.Guardian

  plug(:match)
  plug(:dispatch)

  @doc """
    Register a new customer account
  """
  post "/register" do
    %{"customer" => customer} = conn.body_params

    case Customers.create_customer(customer) do
      {:ok, _customer} ->
        Customers.bind_account(_customer)
        customer = Customers.get_customer(_customer.id)
        Router.render_json(conn, %{message: "Customer created with success!", customer: customer})

      {:error, _changeset} ->
        Router.render_json(conn, %{errors: TranslateError.pretty_errors(_changeset)})
    end
  end

  @doc """
    show current account
  """
  get "/account" do
    token = Router.get_bearer_token(conn)

    with {:ok, customer} <- Guardian.get_user_by_token(token) do
      Router.render_json(conn, %{message: "Customer viewed with success!", customer: customer})
    end
  end

  @doc """
    Withdrawal money from your account
  """
  post "/withdrawal" do
    token = Router.get_bearer_token(conn)
    {:ok, customer} = Guardian.get_user_by_token(token)
    params = conn.body_params
      |> Map.put("customer", customer)

    case Transactions.Action.withdrawal(params) do
      {:error, :zero_value} ->
        Router.render_json(conn, %{errors: "Value cannot be less than 0.00"})
        
      {:error, :unauthorized} ->
        Router.render_json(conn, %{errors: "Invalid credentials"})

      {:error, :not_found} ->
        Router.render_json(conn, %{errors: "Invalid account data"})
      
      {:error, :not_funds} ->
        Router.render_json(conn, %{errors: "You don't have enough funds"})
      
      {:info, _account} ->
        Router.render_json(conn, %{message: "Please check your transation", result: _account})
          
      {:ok, _result} ->
        Router.render_json(conn, %{message: "Successful withdrawal!", result: %{
          "email" => _result.customer.email,
          "new_balance" => _result.balance
        }})
    end
  end

  @doc """
    Transfer money to other customer account
  """
  post "/transfer" do
    token = Router.get_bearer_token(conn)
    {:ok, customer} = Guardian.get_user_by_token(token)
    params = conn.body_params
      |> Map.put("customer", customer)

    case Transactions.Action.transfer(params) do
      {:error, :zero_value} ->
        Router.render_json(conn, %{errors: "Value cannot be less than 0.00"})

      {:error, :unauthorized} ->
        Router.render_json(conn, %{errors: "Invalid credentials"})

      {:error, :not_found} ->
        Router.render_json(conn, %{errors: "Invalid account data"})
      
      {:error, :not_funds} ->
        Router.render_json(conn, %{errors: "You don't have enough funds"})
 
      {:info, _account} ->
        Router.render_json(conn, %{message: "Please check your transation", result: _account})
          
      {:ok, _result} ->
        Router.render_json(conn, %{message: "Successful transfer!", result: %{
          "email" => _result.customer.email,
          "new_balance" => _result.balance
        }})
    end
  end

  @doc """
    Terminate customer account
  """
  get "/terminate", assigns: %{an_option: :a_value} do
    token = Router.get_bearer_token(conn)

    if Guardian.terminate_account(token) do
      Router.render_json(conn, %{message: "Your account has been terminated"})
    else
      Router.render_json(conn, %{errors: "You need authenticated to this action"})
    end
  end

  @doc """
    Default route to page not found
  """
  match _ do
    Router.render_json(conn, %{message: "Page not found"}, 404)
  end
end
