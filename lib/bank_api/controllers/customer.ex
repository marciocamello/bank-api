defmodule BankApi.Controllers.Customer do
  @moduledoc """
    Customer Controller context
  """
  use Plug.Router
  alias BankApi.Repo
  alias BankApi.Auth.Guardian
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
    if Guardian.is_admin(conn) do

      customers = Customers.list_customers()
        |> Repo.preload(:accounts)
        
      Router.render_json(conn, %{message: "Customer listed with success!", customers: customers})
    else

      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Create account route
  """
  post "/" do
    if Guardian.is_admin(conn) do

      %{"customer" => customer} = conn.body_params

      case Customers.create_customer(customer) do
        {:ok, _customer} ->
          Customers.bind_account(_customer)
          customer = Customers.get_customer(_customer.id)
          Router.render_json(conn, %{message: "Customer created with success!", customer: customer})

        {:error, _changeset} ->
          Router.render_json(conn, %{errors: TranslateError.pretty_errors(_changeset)})
      end
    else

      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Show user logged by id
  """
  get "/:id" do
    if Guardian.is_admin(conn) do

      %{"id" => id} = conn.path_params

      case Customers.get_customer(id) do
        nil ->
          Router.render_json(conn, %{errors: "This customer do not exist"})

        customer ->
          Router.render_json(conn, %{message: "Customer viewed with success!", customer: customer})
      end
    else

      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Update user logged by id
  """
  put "/:id" do
    if Guardian.is_admin(conn) do

      %{"id" => id} = conn.path_params
      %{"customer" => params} = conn.body_params

      case Customers.get_customer(id) do
        nil ->
          Router.render_json(conn, %{errors: "This customer do not exist"})

        customer ->
          Customers.update_customer(customer, params)
          Router.render_json(conn, %{message: "Customer updated with success!", customer: customer})
      end
    else

      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Delete user logged by id
  """
  delete "/:id" do
    if Guardian.is_admin(conn) do

      %{"id" => id} = conn.path_params

      case Customers.get_customer(id) do
        nil ->
          Router.render_json(conn, %{errors: "This customer do not exist"})

        customer ->
          Customers.delete_customer(customer)
          Router.render_json(conn, %{message: "Customer deleted with success!"})
      end
    else

      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Default route to page not found
  """
  match _ do
    Router.render_json(conn, %{message: "Page not found"}, 404)
  end
end
