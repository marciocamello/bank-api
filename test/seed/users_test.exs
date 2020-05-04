defmodule BankApiTest.Seed.UsersTest do
  use BankApi.AppCase
  doctest BankApi

  alias BankApi.Seed.Users

  # test add_user function
  test "test add_user" do
    Faker.start()
    assert %Account{} = Users.add_user()
  end
end
