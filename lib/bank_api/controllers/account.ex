defmodule BankApi.Controllers.Account do
  @moduledoc """
    User Controller context
  """
  use Plug.Router
  alias BankApi.Repo
  alias BankApi.Helpers.TranslateError
  alias BankApi.Models.Users
  alias BankApi.Models.Transactions
  alias BankApi.Router
  alias BankApi.Auth.Guardian

  plug(:match)
  plug(:dispatch)

  @doc """
    Create a new user account
  """
  post "/create" do
    %{"user" => user} = conn.body_params

    case Users.create_user(user) do
      {:ok, _user} ->
        Users.bind_account(_user)
        user = Users.get_user(_user.id)
        Router.render_json(conn, %{message: "Account created with success!", user: user})

      {:error, _changeset} ->
        Router.render_json(conn, %{errors: TranslateError.pretty_errors(_changeset)})
    end
  end

  @doc """
    show current account
  """
  get "/index" do
      token = Router.get_bearer_token(conn)

    case Guardian.get_user_by_token(token) do
      {:ok, user} ->
        Router.render_json(conn, %{message: "Account viewed with success!", user: user})

      {:error, :not_found} ->
        Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Withdrawal money from your account
  """
  post "/withdrawal" do
    token = Router.get_bearer_token(conn)

    case Guardian.get_user_by_token(token) do
      {:ok, user} ->
        params =
          conn.body_params
          |> Map.put("user", user)

        case Transactions.Action.withdrawal(params) do
          {:error, :zero_value} ->
            Router.render_json(conn, %{errors: "Value cannot be less than 0.00"})

          {:error, :unauthorized} ->
            Router.render_json(conn, %{errors: "Invalid credentials"})

          {:error, :not_funds} ->
            Router.render_json(conn, %{errors: "You don't have enough funds"})

          {:info, _account} ->
            Router.render_json(conn, %{message: "Please check your transation", result: _account})

          {:ok, _result} ->
            Router.render_json(conn, %{
              message: "Successful withdrawal!",
              result: %{
                "email" => _result.user.email,
                "new_balance" => _result.balance
              }
            })
        end

      {:error, :not_found} ->
        Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Transfer money to other user account
  """
  post "/transfer" do
    token = Router.get_bearer_token(conn)

    case Guardian.get_user_by_token(token) do
      {:ok, user} ->
        params =
          conn.body_params
          |> Map.put("user", user)

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
            Router.render_json(conn, %{
              message: "Successful transfer!",
              result: %{
                "email" => _result.user.email,
                "new_balance" => _result.balance
              }
            })
        end

      {:error, :not_found} ->
        Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Terminate user account
  """
  get "/terminate", assigns: %{an_option: :a_value} do
    token = Router.get_bearer_token(conn)

    case Guardian.terminate_account(token) do
      {:ok, _user} ->
        Router.render_json(conn, %{message: "Your account has been terminated"})

      {:error, :not_found} ->
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
