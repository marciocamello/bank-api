defmodule BankApi.Repo.Migrations.AddAclToCustomers do
  use Ecto.Migration

  def change do
    alter table(:customers) do
      add :acl, :string, default: "customer"
    end
  end
end
