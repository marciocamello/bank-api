defmodule BankApi.Controllers.Auth do
  @moduledoc """
    Auth Controller context
  """
  use Plug.Router
  alias BankApi.Repo
  alias BankApi.Auth.Guardian
  alias BankApi.Router

  plug(:match)
  plug(:dispatch)

  @doc """
    User login and get access token
  """
  post "/login" do
    %{"email" => email, "password" => password} = conn.body_params

    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        Router.render_json(conn, %{message: "Login success!", user: user, token: token})

      {:error, :unauthorized} ->
        Router.render_json(conn, %{errors: "Unauthorized"})

      {:error, :not_found} ->
        Router.render_json(conn, %{errors: "Invalid credentials"})
    end
  end

  @doc """
    Default route to page not found
  """
  match _ do
    Router.render_json(conn, %{message: "Page not found"}, 404)
  end
end
