defmodule BankApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :decimal, precision: 10, scale: 2
      add :customer_id, references(:customers, on_delete: :delete_all, type: :id)

      timestamps()
    end
  end

  def down do
    drop table("accounts")
  end
end