defmodule BankApi.Router do
  @moduledoc """
    BankApi router context
  """
  use Plug.Router
  alias BankApi.Controllers.{Auth, User, Account, Transaction}

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(CORSPlug)
  plug(:dispatch)

  @doc """
    Render parser to request data from route
  """
  def render_json(conn, data, status \\ 200) do
    body = Jason.encode!(data)
    send_resp(conn, status, body)
  end

  @doc false
  def get_header(conn, key) do
    get_req_header(conn, key)
  end

  @doc """
    Render parser to request data from route
  """
  def get_bearer_token(conn) do
    [bearer] = get_header(conn, "authorization")
    String.replace(bearer, "Bearer ", "")
  end

  @doc false
  get "/" do
    render_json(conn, %{message: "BankAPI V1 - Check docs to how to use"})
  end

  @doc false
  forward("/api/auth", to: Auth)

  @doc false
  forward("/api/account", to: Account)

  @doc false
  forward("/api/transactions", to: Transaction)

  @doc false
  forward("/api/users", to: User)

  @doc false
  match _ do
    render_json(conn, %{message: "Page not found"}, 404)
  end
end
