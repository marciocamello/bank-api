defmodule BankApi.Controllers.Customer do
  @moduledoc """
  """
  alias BankApi.Helpers.TranslateError
  alias BankApi.Models.Customers
  alias BankApi.Router

  @doc """
  Show account logged
  """
  def index(conn) do
    customers = Customers.list_customers()

    Router.render_json(conn, %{message: "Customer liested with success!", customers: customers})
  end

  @doc """
  Create account route
  """
  def create(conn) do
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
  def show(conn) do
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
  def update(conn) do
    %{"id" => id} = conn.path_params
    %{"customer" => params} = conn.body_params

    case Customers.get_customer(id) do
      nil ->
        Router.render_json(conn, %{errors: "This customer do not exist"})
      customer ->
        Customers.update_customer(customer, params)
        Router.render_json(conn, %{message: "Customer updated with success!", customer: customer })
    end
  end

  @doc """
  Delete user logged by id
  """
  def delete(conn) do
    %{"id" => id} = conn.path_params

    case Customers.get_customer(id) do
      nil ->
        Router.render_json(conn, %{errors: "This customer do not exist"})
      customer ->
        Customers.delete_customer(customer)
        Router.render_json(conn, %{message: "Customer deleted with success!" })
    end
  end
end
