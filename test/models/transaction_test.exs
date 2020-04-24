defmodule BankApi.Model.TransactionTest do
  use BankApi.AppCase
  doctest BankApi

  # get_total_transactions return 0
  test "transactions get_total_transactions return 0" do
    assert Transactions.get_total_transactions([]) == 0
  end

  # get_total_transactions return values
  test "transactions get_total_transactions return values" do
    transaction =
      Transactions.get_total_transactions([
        %BankApi.Schemas.Transaction{
          account_from: "1@gmail.com",
          account_to: "1@gmail.com",
          id: 5,
          inserted_at: ~N[2020-04-22 02:21:49],
          type: "withdrawal",
          updated_at: ~N[2020-04-22 02:21:49],
          value: "10.00"
        }
      ])

    assert Decimal.eq?(transaction, Decimal.from_float(10.00)) == true
  end
end
