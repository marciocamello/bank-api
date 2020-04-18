defmodule BankApi.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :firstName, :string, null: false
      add :lastName, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :phone, :string

      timestamps()
    end

    create unique_index(:customers, [:email])
  end
end
