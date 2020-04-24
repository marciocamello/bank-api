defmodule BankApi.Fixtures do
  @moduledoc """
  A module for defining fixtures that can be used in tests.
  """

  @doc false
  def customer do
    alias BankApi.Auth.Guardian
    alias BankApi.Models.Customers
    alias BankApi.Schemas.Account
    alias BankApi.Schemas.Customer

    quote do
      @create_attrs %{
        email: "test@email.com",
        firstName: "Test",
        lastName: "Marcio",
        phone: "37 98406 2829",
        password: "123123123",
        acl: "customer"
      }

      @create2_attrs %{
        email: "tes2t@email.com",
        firstName: "Test2",
        lastName: "Andre",
        phone: "37 98406 2829",
        password: "123123123",
        acl: "customer"
      }

      @update_attrs %{
        email: "test_update@email.com",
        firstName: "Test Update",
        lastName: "Marcio Jose",
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

      @transfer_attrs %{
        "account_to" => @create_attrs.email,
        "value" => 10.00,
        "password_confirm" => false
      }

      @transfer_confirm_attrs %{
        "account_to" => @create_attrs.email,
        "value" => 10.00,
        "password_confirm" => @create_attrs.password
      }

      @doc false
      def create_customer(attrs \\ @create_attrs) do
        {:ok, customer} = Customers.create_customer(attrs)
      end

      @doc false
      def bind_account(customer) do
        Customers.bind_account(customer)
      end

      @doc false
      def auth(attrs \\ @create_attrs) do
        Guardian.authenticate(attrs.email, attrs.password)
      end

      @doc false
      def auth_customer(attrs \\ @create_attrs) do
        {:ok, customer, token} = auth()
      end

      @doc false
      def get_customer(id) do
        Customers.get_customer(id)
      end

      @doc false
      def get_user_by_token(token) do
        {:ok, customer} = Guardian.get_user_by_token(token)
      end

      @doc false
      def create_customers do
        {:ok, customer} =
          Customers.create_customer(%{
            email: Faker.Internet.email(),
            firstName: Faker.Name.PtBr.name(),
            lastName: Faker.Name.PtBr.name(),
            password: "123123123",
            phone: Faker.Phone.EnUs.phone(),
            acl: "customer"
          })

        Customers.bind_account(customer)
      end

      @doc false
      def seed_customers(count) do
        for n <- 1..count do
          create_customers()
        end
      end

      @doc false
      def create_customer_and_token do
        {:ok, customer} = create_customer()
        bind_account(customer)
        {:ok, customer, token} = auth_customer()
      end

      @doc false
      def create_customer_and_authenticate do
        {:ok, customer} = create_customer()
        bind_account(customer)
        {:ok, customer, token} = auth_customer()
        {:ok, customer} = get_user_by_token(token)
      end

      @doc false
      def create_customer_and_authenticate_token do
        {:ok, customer} = create_customer()
        bind_account(customer)
        {:ok, customer, token} = auth_customer()
      end

      @doc false
      def create_customer_and_authenticate_transfer do
        # acccount receive money
        {:ok, customer} = create_customer(@create_attrs)
        bind_account(customer)

        # account sender money
        {:ok, customer} = create_customer(@create2_attrs)
        bind_account(customer)
        {:ok, customer, token} = auth_customer(@create2_attrs)
        {:ok, customer} = get_user_by_token(token)
      end

      @doc false
      def create_customer_and_authenticate_transfer_token do
        # acccount receive money
        {:ok, customer} = create_customer(@create_attrs)
        bind_account(customer)

        # account sender money
        {:ok, customer} = create_customer(@create2_attrs)
        bind_account(customer)
        {:ok, customer, token} = auth_customer(@create2_attrs)
      end
    end
  end

  @doc false
  def transaction do
    alias BankApi.Models.Customers
    alias BankApi.Schemas.Customer
    alias BankApi.Auth.Guardian

    quote do
      @create_admin_attrs %{
        email: "admin_test@email.com",
        firstName: "Admin",
        lastName: "Test",
        phone: "37 98406 2829",
        password: "123123123",
        acl: "admin"
      }

      @all_attrs %{
        "filter" => "",
        "type" => "",
        "period" => ""
      }

      @daily_attrs %{
        "filter" => "daily",
        "type" => "",
        "period" => Date.utc_today().day |> Integer.to_string()
      }

      @monthly_attrs %{
        "filter" => "monthly",
        "type" => "",
        "period" => Date.utc_today().month |> Integer.to_string()
      }

      @yearly_attrs %{
        "filter" => "yearly",
        "type" => "",
        "period" => Date.utc_today().year |> Integer.to_string()
      }

      @doc false
      def create_admin(attrs \\ @create_admin_attrs) do
        {:ok, admin} = Customers.create_customer(attrs)
      end

      @doc false
      def auth_admin(attrs \\ @create_admin_attrs) do
        {:ok, customer, token} = Guardian.authenticate(attrs.email, attrs.password)
      end

      @doc false
      defp create_transactions(customer) do
        params =
          @withdrawal_confirm_attrs
          |> Map.put("customer", customer)
      end

      @doc false
      def seed_transactions(customer, list, count) do
        for n <- 1..count do
          create_transactions(customer)
        end
      end
    end
  end

  @doc """
  Apply the `fixtures`.
  """
  defmacro __using__(fixtures) when is_list(fixtures) do
    for fixture <- fixtures, is_atom(fixture), do: apply(__MODULE__, fixture, [])
  end
end
