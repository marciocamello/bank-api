defmodule BankApi.Context.UsersTest do
  use BankApi.AppCase
  use Plug.Test
  doctest BankApi

  # global fixtures
  use BankApi.Fixtures, [:user, :transaction]

  describe "users" do
    # create user
    test "Create admin account" do
      assert {:ok, user} = create_admin()
      assert %User{} = Users.get_user(user.id)
    end

    # list all users
    test "List all users" do
      assert {:ok, %User{}} = create_user()

      users =
        Users.list_users()
        |> Repo.preload(:accounts)

      assert [%BankApi.Schemas.User{}] = users
    end

    # create user
    test "Create user" do
      assert {:ok, user} = create_user()
      assert %Account{} = bind_account(user)
    end

    # create user failed changeset
    test "Create user failed changeset" do
      {:error, _changeset} = Users.create_user()
    end

    # update user
    test "Update user" do
      assert {:ok, user} = create_user()
      user = get_user(user.id)

      assert {:ok, %User{}} = Users.update_user(user, @update_attrs)
    end

    # delete user
    test "Delete user" do
      assert {:ok, user} = create_user()
      assert %Account{} = bind_account(user)
      user = get_user(user.id)

      assert {:ok, %User{}} = Users.delete_user(user)
    end
  end
end
