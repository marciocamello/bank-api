defmodule BankApi.Router do
  @moduledoc """
  """
  use Plug.Router
  alias BankApi.Plugs.VerifyRequest
  alias BankApi.Plugs.{RequireAuth}
  alias BankApi.Controllers.{Auth, Home, Customer}

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
    render_json(conn, %{message: "pong", status: 200})
  end

  # Auth routes
  forward "/api/login", to: Auth

  # Customer routes
  forward "/api/customers", to: Customer

  # Home routes
  forward "/", to: Home

  @doc """
  Default route to page not found
  """
  match _ do
    render_json(conn, %{message: "Page not found", status: 404})
  end
end
