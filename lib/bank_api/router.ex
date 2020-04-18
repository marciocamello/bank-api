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
  Show account logged
  """
  get "/api/customers" do
    customers = Customers.list_customers()

    render_json(conn, %{message: "Customer liested with success!", customers: customers})
  end

  @doc """
  Create account route
  """
  post "/api/customers" do
    %{"customer" => customer} = conn.body_params

    case Customers.create_customer(customer) do
      {:ok, _customer} ->
        render_json(conn, %{message: "Customer created with success!", customer: _customer})
      {:error, _changeset} ->
        render_json(conn, %{errors: TranslateError.pretty_errors(_changeset)})
    end
  end

  @doc """
  Show user logged by id
  """
  get "/api/customers/:id" do
    %{"id" => id} = conn.path_params

    case Customers.get_customer(id) do
      nil ->
        render_json(conn, %{errors: "This customer do not exist"})
      customer ->
        render_json(conn, %{message: "Customer viewed with success!", customer: customer})
      end
  end

  @doc """
  Update user logged by id
  """
  put "/api/customers/:id" do
    %{"id" => id} = conn.path_params
    %{"customer" => params} = conn.body_params

    case Customers.get_customer(id) do
      nil ->
        render_json(conn, %{errors: "This customer do not exist"})
      customer ->
        Customers.update_customer(customer, params)
        render_json(conn, %{message: "Customer updated with success!", customer: customer })
    end
  end

  @doc """
  Delete user logged by id
  """
  delete "/api/customers/:id" do
    %{"id" => id} = conn.path_params

    case Customers.get_customer(id) do
      nil ->
        render_json(conn, %{errors: "This customer do not exist"})
      customer ->
        Customers.delete_customer(customer)
        render_json(conn, %{message: "Customer deleted with success!" })
    end
  end

  @doc """
  Default route to page not found
  """
  match _ do
    send_resp(conn, 404, "404 - Page not found")
  end
end
