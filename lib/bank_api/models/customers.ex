defmodule BankApi.Models.Customers do
  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Schemas.Customer

  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end
end
