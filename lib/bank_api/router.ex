defmodule BankApi.Router do
  @moduledoc """
  """
  use Plug.Router
  alias BankApi.Controllers.{Home, Customer}
  alias BankApi.Plug.VerifyRequest

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

  # Home routes
  get "/", do: Home.index(conn)

  # Customers routes
  get "/api/customers", do: Customer.index(conn)
  get "/api/customers/:id", do: Customer.show(conn)
  post "/api/customers", do: Customer.create(conn)
  put "/api/customers/:id", do: Customer.update(conn)
  delete "/api/customers/:id", do: Customer.delete(conn)

  @doc """
  Default route to page not found
  """
  match _ do
    render_json(conn, %{message: "Page not found", status: 404})
  end
end
