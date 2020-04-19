defmodule BankApi.Router do
  @moduledoc """
    BankApi router context
  """
  use Plug.Router
  alias BankApi.Plugs.VerifyRequest
  alias BankApi.Controllers.{Auth, Home, Customer, User}

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
    Render parser to request data from route
  """
  def get_header(%{req_headers: req_headers} = conn, key) do
    get_req_header(conn, key)
  end

  @doc """
    Render parser to request data from route
  """
  def get_bearer_token(conn) do
    [bearer] = get_header(conn, "authorization")
    String.replace(bearer, "Bearer ", "")
  end

  @doc """
    Ping route to check service status
  """
  get "/ping" do
    render_json(conn, %{message: "pong", status: 200})
  end

  @doc """
    Auth routes
  """
  forward("/api/auth", to: Auth)

  @doc """
    User routes
  """
  forward("/api/user", to: User)

  @doc """
    Customer routes (only dev)
  """
  forward("/api/customers", to: Customer)

  @doc """
    Home routes
  """
  forward("/", to: Home)

  @doc """
    Default route to page not found
  """
  match _ do
    render_json(conn, %{message: "Page not found", status: 404})
  end
end
