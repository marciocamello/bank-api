defmodule BankApi.Context.TransactionsTest do
  use BankApi.AppCase, assync: true
  use Plug.Test
  doctest BankApi

  # global fixtures
  use BankApi.Fixtures, [:user, :transaction]

  describe "transactions" do
    # create user
    test "Create admin account" do
      assert {:ok, user} = create_admin()
      assert %User{} = Users.get_user(user.id)
    end

    # list all transactions
    test "List all transactions" do
      assert {:ok, user} = create_admin()
      assert {:ok, _, token} = auth_admin()

      if assert Guardian.is_admin(token) == true do
        %{
          "filter" => filter,
          "type" => type,
          "period" => period
        } = @all_attrs

        assert %{"total" => total, "transactions" => transactions} =
                 Transactions.filter_transactions(filter, type, period)
      end
    end

    # list daily transactions
    test "List daily transactions" do
      assert {:ok, user} = create_admin()
      assert {:ok, _, token} = auth_admin()

      if assert Guardian.is_admin(token) == true do
        %{
          "filter" => filter,
          "type" => type,
          "period" => period
        } = @daily_attrs

        assert %{"total" => total, "transactions" => transactions} =
                 Transactions.filter_transactions(filter, type, period)
      end
    end

    # list monthly transactions
    test "List monthly transactions" do
      assert {:ok, user} = create_admin()
      assert {:ok, _, token} = auth_admin()

      if assert Guardian.is_admin(token) == true do
        %{
          "filter" => filter,
          "type" => type,
          "period" => period
        } = @monthly_attrs

        assert %{"total" => total, "transactions" => transactions} =
                 Transactions.filter_transactions(filter, type, period)
      end
    end

    # list yearly transactions
    test "List yearly transactions" do
      assert {:ok, user} = create_admin()
      assert {:ok, _, token} = auth_admin()

      if assert Guardian.is_admin(token) == true do
        %{
          "filter" => filter,
          "type" => type,
          "period" => period
        } = @yearly_attrs

        assert %{"total" => total, "transactions" => transactions} =
                 Transactions.filter_transactions(filter, type, period)
      end
    end
  end
end
