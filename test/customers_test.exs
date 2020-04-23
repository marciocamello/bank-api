defmodule BankApiCustomersTest do
  use BankApi.AppCase, assync: true
  doctest BankApi

  # sandbox sql setup
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BankApi.Repo)
  end

  # global fixtures
  use BankApi.Fixtures, [:customer]

  # register user
  test "Create customer account" do
    assert {:ok, _customer} = create_customer
    assert %Account{} = Customers.bind_account(_customer)
    assert %Customer{} = Customers.get_customer(_customer.id)
  end

  # login user
  test "Login customer account" do
    assert {:ok, _customer} = create_customer
    assert {:ok, %Customer{}, _token} = auth_customer
  end

  # failed login user
  test "Failed Login customer account" do
    assert {:ok, _customer} = create_customer
    assert {:error, :unauthorized} =  Guardian.authenticate(@create_attrs.email, "wrongpassword")
  end

  # show current user
  test "Show current customer account" do
    assert {:ok, _customer} = create_customer
    assert {:ok, %Customer{}, _token} = auth_customer
    assert {:ok, customer} = get_user_by_token(_token)
  end
end
