defmodule BankApiAuthTest do
  use BankApi.AppCase, assync: true
  doctest BankApi

  # globalfixtures
  use BankApi.Fixtures, [:customer]

  describe "auth" do
    # login customer account
    test "Login customer account" do
      assert {:ok, customer} = create_customer()
      assert {:ok, %Customer{}, token} = auth_customer()
    end

    # login customer account unauthorized
    test "Login customer account unauthorized" do
      assert {:ok, customer} = create_customer()

      assert {:error, :unauthorized} =
               auth(%{
                 email: customer.email,
                 password: "23423werwer"
               })
    end

    # login customer account invalid credentials
    test "Login customer account invalid credentials" do
      assert {:ok, customer} = create_customer()

      assert {:error, :not_found} =
               auth(%{
                 email: "",
                 password: ""
               })
    end
  end
end
