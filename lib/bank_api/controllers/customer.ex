defmodule BankApi.Controllers.Customer do
  @moduledoc """
    Customer Controller context
  """
  use Plug.Router
  alias BankApi.Helpers.TranslateError
  alias BankApi.Models.Customers
  alias BankApi.Router

  plug(:match)
  plug(BankApi.Auth.Pipeline)
  plug(:dispatch)

  @doc """
    Show account logged
  """
  get "/" do
    customers = Customers.list_customers()

    Router.render_json(conn, %{message: "Customer liested with success!", customers: customers})
  end

  @doc """
    Create account route
  """
  post "/" do
    %{"customer" => customer} = conn.body_params

    case Customers.create_customer(customer) do
      {:ok, _customer} ->
        Router.render_json(conn, %{message: "Customer created with success!", customer: _customer})

      {:error, _changeset} ->
        Router.render_json(conn, %{errors: TranslateError.pretty_errors(_changeset)})
    end
  end

  @doc """
    Show user logged by id
  """
  get "/:id" do
    %{"id" => id} = conn.path_params

    case Customers.get_customer(id) do
      nil ->
        Router.render_json(conn, %{errors: "This customer do not exist"})

      customer ->
        Router.render_json(conn, %{message: "Customer viewed with success!", customer: customer})
    end
  end

  @doc """
    Update user logged by id
  """
  put "/:id" do
    %{"id" => id} = conn.path_params
    %{"customer" => params} = conn.body_params

    case Customers.get_customer(id) do
      nil ->
        Router.render_json(conn, %{errors: "This customer do not exist"})

      customer ->
        Customers.update_customer(customer, params)
        Router.render_json(conn, %{message: "Customer updated with success!", customer: customer})
    end
  end

  @doc """
    Delete user logged by id
  """
  delete "/:id" do
    %{"id" => id} = conn.path_params

    case Customers.get_customer(id) do
      nil ->
        Router.render_json(conn, %{errors: "This customer do not exist"})

      customer ->
        Customers.delete_customer(customer)
        Router.render_json(conn, %{message: "Customer deleted with success!"})
    end
  end
end
