defmodule BankApiWithDrawalTest do
  use BankApi.AppCase, assync: true
  doctest BankApi

  # sandbox sql setup
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BankApi.Repo)
  end

  # global fixtures
  use BankApi.Fixtures, [:customer]

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
