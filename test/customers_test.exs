defmodule BankApiCustomersTest do
  use BankApi.AppCase
  use Plug.Test
  doctest BankApi

  # global fixtures
  use BankApi.Fixtures, [:customer, :transaction]

  describe "customers" do
    # register user
    test "Create admin account" do
      assert {:ok, customer} = create_admin()
      assert %Customer{} = Customers.get_customer(customer.id)
    end

    # list all customers
    test "List all customers" do
      assert {:ok, %Customer{}} = create_customer()

      customers =
        Customers.list_customers()
        |> Repo.preload(:accounts)

      assert [%BankApi.Schemas.Customer{}] = customers
    end

    # create customer
    test "Create customer" do
      assert {:ok, customer} = create_customer()
      assert %Account{} = bind_account(customer)
    end

    # create customer failed changeset
    test "Create customer failed changeset" do
      {:error, _changeset} = Customers.create_customer(%{})
    end

    # update customer
    test "Update customer" do
      assert {:ok, customer} = create_customer()
      customer = get_customer(customer.id)

      assert {:ok, %Customer{}} = Customers.update_customer(customer, @update_attrs)
    end

    # delete customer
    test "Delete customer" do
      assert {:ok, customer} = create_customer()
      assert %Account{} = bind_account(customer)
      customer = get_customer(customer.id)

      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
    end
  end
end
