defmodule BankApi.Context.AuthTest do
  use BankApi.AppCase, assync: true
  doctest BankApi

  # globalfixtures
  use BankApi.Fixtures, [:user]

  describe "auth" do
    # login user account
    test "Login user account" do
      assert {:ok, user} = create_user()
      assert {:ok, %User{}, token} = auth_user()
    end

    # login user account unauthorized
    test "Login user account unauthorized" do
      assert {:ok, user} = create_user()

      assert {:error, :unauthorized} =
               auth(%{
                 email: user.email,
                 password: "23423werwer"
               })
    end

    # login user account invalid credentials
    test "Login user account invalid credentials" do
      assert {:ok, user} = create_user()

      assert {:error, :not_found} =
               auth(%{
                 email: "",
                 password: ""
               })
    end
  end
end
