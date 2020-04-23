defmodule BankApiTransactionsTest do
  use BankApi.AppCase, assync: true
  use Plug.Test
  doctest BankApi

  # sandbox sql setup
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BankApi.Repo)
  end

  # global fixtures
  use BankApi.Fixtures, [:customer, :transaction]

  describe "transactions" do

    # register user
    test "Create admin account" do
      assert {:ok, _admin} = create_admin
      assert %Customer{} = Customers.get_customer(_admin.id)
    end

    # list all transactions
    test "List all transactions" do
      
      assert {:ok, _admin} = create_admin
      assert {:ok, %Customer{}, _token} = auth_admin
      
      if assert Guardian.is_admin(_token) == true do

        %{
          "filter" => filter,
          "type" => type,
          "period" => period
        } = @all_attrs
      
        assert %{"total" => total, "transactions" => transactions} = Transactions.filter_transactions(filter, type, period)
      end
    end
  end
end
