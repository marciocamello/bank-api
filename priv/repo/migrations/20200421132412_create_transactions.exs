defmodule BankApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :decimal, precision: 10, scale: 2
      add :account_from, :string
      add :account_to, :string
      
      timestamps()
    end
  end

  def down do
    drop table("transactions")
  end
end
