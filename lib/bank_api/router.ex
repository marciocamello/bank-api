defmodule BankApi.Router do
  @moduledoc """
  """
  use Plug.Router
  alias BankApi.Plug.VerifyRequest
  alias BankApi.Models.Customers
  alias BankApi.Helpers.TranslateError

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  @doc """
  Render parser to request data from route
  """
  def render_json(%{status: status} = conn, data) do
    body = Jason.encode!(data)
    send_resp(conn, status || 200, body)
  end

  @doc """
  Ping route to check service status
  """
  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  @doc """
  Home route
  """
  get "/" do
    send_resp(conn, 200, "BankAPI - Check docs to how to use")
  end

  @doc """
  Default route to logged user account
  """
  get "/api/account" do
    account = %{
      firstName: "Marcio",
      lastName: "André",
      email: "marciocamello@outlook.com",
      phone: "37 98406 2829"
    }

    render_json(conn, %{account: account})
  end

  def convert_changeset_errors(changeset) do
    out =
      Ecto.Changeset.errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    out
  end

  @doc """
  Default route to logged user account
  """
  post "/api/account" do
    account = conn.body_params["account"]

    case Customers.create_customer(account) do
      {:ok, _account} ->
        render_json(conn, _account)
      {:error, _changeset} ->
        render_json(conn, %{errors: TranslateError.pretty_errors(_changeset)})
    end
  end

  @doc """
  Default route to page not found
  """
  match _ do
    send_resp(conn, 404, "404 - Page not found")
  end
end
