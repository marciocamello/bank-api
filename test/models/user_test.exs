defmodule BankApi.Model.UserTest do
  use BankApi.AppCase
  doctest BankApi

  # global fixtures
  use BankApi.Fixtures, [:user]

  # get_user_authenticated by id
  test "Users get_user_authenticated by id" do
    {:ok, _user} = create_user()
  end
end
