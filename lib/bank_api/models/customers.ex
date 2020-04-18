defmodule BankApi.Models.Customers do
  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Schemas.Customer

  def list_customers do
    Repo.all(Customer)
  end

  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  def get_customer(id) do
    Repo.get(Customer, id)
  end

  def update_customer(%Customer{} = customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
  end

  def delete_customer(%Customer{} = customer) do
    Repo.delete(customer)
  end

  def login(email, password) do
    Repo.get_by(Customer, email: email)
  end

  def get_by_email(email) do
    case Repo.get_by(Customer, email: email) do
      nil ->
        {:error, :not_found}
      user ->
        {:ok, user}
    end
  end
end
