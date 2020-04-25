defmodule BankApiTest.Seed.AdminTest do
  use BankApi.AppCase
  doctest BankApi

  alias BankApi.Seed.Admin

  # test add_admin function
  test "test add_admin" do
    Faker.start()
    assert {:ok, %User{}} = Admin.add_admin()
  end
end
