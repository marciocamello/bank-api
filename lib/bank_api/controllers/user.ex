defmodule BankApi.Controllers.User do
  @moduledoc """
    User Controller context
  """
  use Plug.Router
  alias BankApi.Repo
  alias BankApi.Helpers.TranslateError
  alias BankApi.Models.Customers
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
