defmodule BankApi.Model.CustomerTest do
  use BankApi.AppCase
  doctest BankApi

  # global fixtures
  use BankApi.Fixtures, [:customer]

  # get_user_authenticated by id
  test "Customers get_user_authenticated by id" do
    {:ok, _customer} = create_customer()
  end
end
