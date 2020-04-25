defmodule BankApiTest.Seed.UsersTest do
  use BankApi.AppCase
  doctest BankApi

  alias BankApi.Seed.Users

  # test add_user function
  test "test add_user" do
    Faker.start()
    assert {ok, %User{}} = Users.add_user()
  end
end
