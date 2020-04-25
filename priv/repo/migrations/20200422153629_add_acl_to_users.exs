defmodule BankApi.Repo.Migrations.AddAclToCustomers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :acl, :string, default: "user"
    end
  end
end
