defmodule BankApiControllersTest do
  use ExUnit.Case
  doctest BankApi

  alias BankApi.Repo
  alias BankApi.Models.Customers
  alias BankApi.Models.Transactions
  alias BankApi.Schemas.Customer
  alias BankApi.Schemas.Account
  alias BankApi.Auth.Guardian
  alias BankApi.Helpers.TranslateError

  # sandbox sql setup
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  # fixtures
  @create_attrs %{
    email: "test@email.com",
    firstName: "Test",
    lastName: "Marcio",
    phone: "37 98406 2829",
    password: "123123123",
    acl: "customer"
  }

  @withdrawal_attrs %{
	  "value" => 10.00,
	  "password_confirm" => false
  }

  @withdrawal_confirm_attrs %{
	  "value" => 10.00,
	  "password_confirm" => @create_attrs.password
  }

  def create_customer do
    {:ok, customer} = Customers.create_customer(@create_attrs)
  end

  def bind_account(customer) do
     Customers.bind_account(customer)
  end

  def auth_customer do
    {:ok, %Customer{}, _token} =  Guardian.authenticate(@create_attrs.email, @create_attrs.password)
  end

  def get_customer(id) do
    Customers.get_customer(id)
  end

  def get_user_by_token(token) do
    {:ok, customer} = Guardian.get_user_by_token(token)
  end

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

  # withdrawal money from you user and check confirmation password
  test "Withdrawal money from you user and check confirmation password" do
    assert {:ok, _customer} = create_customer
    assert %Account{} = bind_account(_customer)
    assert {:ok, %Customer{}, _token} = auth_customer
    assert {:ok, customer} = get_user_by_token(_token)

    params = @withdrawal_attrs
      |> Map.put("customer", customer)

    assert {:info, _account} = Transactions.Action.withdrawal(params)
  end

  # withdrawal money from you user and confirm password
  test "Withdrawal money from you user and confirm password" do
    assert {:ok, _customer} = create_customer
    assert %Account{} = bind_account(_customer)
    assert {:ok, %Customer{}, _token} = auth_customer
    assert {:ok, customer} = get_user_by_token(_token)

    params = @withdrawal_confirm_attrs
      |> Map.put("customer", customer)

    assert {:ok, _result} = Transactions.Action.withdrawal(params)
  end

  # withdrawal check have funds in account
  test "Withdrawal check have funds in account" do
    assert {:ok, _customer} = create_customer
    assert %Account{} = bind_account(_customer)
    assert {:ok, %Customer{}, _token} = auth_customer
    assert {:ok, customer} = get_user_by_token(_token)

    params = @withdrawal_confirm_attrs
      |> Map.put("value", 2000.00)
      |> Map.put("customer", customer)

    assert {:error, :not_funds} = Transactions.Action.withdrawal(params)
  end

  # withdrawal check zero value
  test "Withdrawal check zero value" do
    assert {:ok, _customer} = create_customer
    assert %Account{} = bind_account(_customer)
    assert {:ok, %Customer{}, _token} = auth_customer
    assert {:ok, customer} = get_user_by_token(_token)

    params = @withdrawal_confirm_attrs
      |> Map.put("value", 0.00)
      |> Map.put("customer", customer)

    assert {:error, :zero_value} = Transactions.Action.withdrawal(params)
  end
end
