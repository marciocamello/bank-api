defmodule BankApiAuthTest do
  use BankApi.AppCase, assync: true
  doctest BankApi

  # sandbox sql setup
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BankApi.Repo)
  end

  # globalfixtures
  use BankApi.Fixtures, [:customer]

  describe "auth" do
    # login user
    test "Login customer account" do
      assert {:ok, _customer} = create_customer
      assert {:ok, %Customer{}, _token} = auth_customer
    end
  end
end
