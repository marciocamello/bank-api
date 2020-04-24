defmodule BankApi.Models.Customers do
  @moduledoc """
    Customers model
  """
  import Ecto
  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Schemas.Customer
  alias BankApi.Router

  @doc """
    List all customers

  # Examples
      iex> alias BankApi.Models.Customers
      iex> Customers.list_customers
      [ %BankApi.Schemas.Customer{} ]
  """
  def list_customers do
    Repo.all(Customer)
  end

  @doc """
    Create customer

  # Examples
      iex> alias BankApi.Models.Customers
      iex> Customers.create_customer(
        %{
          "email" => "email@email.com",
          "firstName" => "firstName",
          "lastName" => "lastName",
          "phone" => "00 0000 0000",
          "password" => "123456"
        }
      )
      { :ok, %BankApi.Schemas.Customer{} }
  """
  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Bind account to customer

  # Examples
      iex> alias BankApi.Models.Customers
      iex> customer = Customers.get_customer(id)
      iex> account = Customers.bind_account(customer)
      %BankApi.Schemas.Account{}
  """
  def bind_account(customer) do
    Ecto.build_assoc(customer, :accounts)
    |> Repo.insert!()
  end

  @doc """
    Get customer from id

  # Examples
      iex> alias BankApi.Models.Customers
      iex> Customers.create_customer(
        %{
          "email" => "email@email.com",
          "firstName" => "firstName",
          "lastName" => "lastName",
          "phone" => "00 0000 0000",
          "password" => "123456"
        }
      )
      { :ok, %BankApi.Schemas.Customer{} }
  """
  def get_customer(id) do
    Repo.get(Customer, id)
    |> Repo.preload(accounts: [:customer])
  end

  @doc """
    Update customer from customer instance

  # Examples
      iex> alias BankApi.Models.Customers
      iex> customer = Customers.get_customer(id)
      iex> Customers.update_customer(
        customer,
        %{
          "email" => "new_email@email.com",
          "firstName" => "New_firstName",
          "lastName" => "New_lastName",
          "phone" => "11 1111 1111",
          "password" => "654321"
        }
      )
      { :ok, %BankApi.Schemas.Customer{} }
  """
  def update_customer(%Customer{} = customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
    Get customer from email

  # Examples
      iex> alias BankApi.Models.Customers
      iex> Customers.get_by_email(
        "email@email.com"
      )
      { :ok, %BankApi.Schemas.Customer{} }
  """
  def get_by_email(email) do
    case Repo.get_by(Customer, email: email) do
      nil ->
        {:error, :not_found}

      customer ->
        customer =
          customer
          |> Repo.preload(accounts: [:customer])

        {:ok, customer}
    end
  end

  @doc """
    Delete customer from customer instance

  # Examples
      iex> alias BankApi.Models.Customers
      iex> customer = Customers.get_customer(id)
      iex> Customers.delete_customer(customer)
      { :ok, %BankApi.Schemas.Customer{} }
  """
  def delete_customer(%Customer{} = customer) do
    Repo.delete(customer)
  end
end
