defmodule BankApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstName, :string, null: false
      add :lastName, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :phone, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end

  def down do
    drop table("users")
  end
end
