defmodule BankApi.Context.TransactionsTest do
  use BankApi.AppCase, assync: true
  use Plug.Test
  doctest BankApi

  # global fixtures
  use BankApi.Fixtures, [:user, :transaction]

  describe "transactions" do
    # insert transaction
    test "Insert transaction" do
      date = Faker.DateTime.between(~N[2019-05-05 00:00:00], ~N[2020-05-05 00:00:00])

      transaction = %{
        value: Enum.random(10..500) |> Integer.to_string,
        account_from: Faker.Internet.email(),
        account_to: Faker.Internet.email(),
        type: "withdrawal",
        inserted_at:  date,
        updated_at:  date,
      }
      assert {:ok, %{}} = Transactions.create_transaction(transaction)
    end

    # insert transaction changeset null
    test "Insert transaction changeset null" do
      assert {:error, %{}} = Transactions.create_transaction()
    end

    # create user
    test "Create admin account" do
      assert {:ok, user} = create_admin()
      assert %User{} = Users.get_user(user.id)
    end

    # list all transactions
    test "List all transactions" do
      assert {:ok, user} = create_admin()
      assert {:ok, _, token} = auth_admin()

      seed_withdrawal(100)
      seed_transfers(100)

      if assert Guardian.is_admin(token) == true do
        assert %{"total" => total, "transactions" => transactions} =
                 Transactions.filter_transactions("", "", "")
      end
    end

    # list all transactions wrong filter
    test "List all transactions wrong filter" do
      assert {:ok, user} = create_admin()
      assert {:ok, _, token} = auth_admin()

      seed_withdrawal(100)
      seed_transfers(100)

      if assert Guardian.is_admin(token) == true do
        assert %{"total" => total, "transactions" => transactions} =
                 Transactions.filter_transactions("wrong_filter", "", "")
      end
    end

    # list daily transactions
    test "List daily transactions" do
      assert {:ok, user} = create_admin()
      assert {:ok, _, token} = auth_admin()

      seed_withdrawal(100)
      seed_transfers(100)

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

      seed_withdrawal(100)
      seed_transfers(100)

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

      seed_withdrawal(100)
      seed_transfers(100)

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
