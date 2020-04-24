defmodule BankApi.Fixtures do
  @moduledoc """
  A module for defining fixtures that can be used in tests.
  """

  def customer do
    alias BankApi.Models.Customers
    alias BankApi.Schemas.Customer
    alias BankApi.Schemas.Account
    alias BankApi.Auth.Guardian

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
      def auth_customer(attrs \\ @create_attrs) do
        {:ok, %Customer{}, _token} = Guardian.authenticate(attrs.email, attrs.password)
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
        {:ok, _customer} =
          Customers.create_customer(%{
            email: Faker.Internet.email(),
            firstName: Faker.Name.PtBr.name(),
            lastName: Faker.Name.PtBr.name(),
            password: "123123123",
            phone: Faker.Phone.EnUs.phone(),
            acl: "customer"
          })

        Customers.bind_account(_customer)
      end

      @doc false
      def seed_customers(count) do
        for n <- 1..count do
          create_customers()
        end
      end

      @doc false
      def create_customer_and_token do
        {:ok, _customer} = create_customer
        %Account{} = bind_account(_customer)
        {:ok, %Customer{}, _token} = auth_customer
      end

      @doc false
      def create_customer_and_authenticate do
        {:ok, _customer} = create_customer
        %Account{} = bind_account(_customer)
        {:ok, %Customer{}, _token} = auth_customer
        {:ok, _customer} = get_user_by_token(_token)
      end

      @doc false
      def create_customer_and_authenticate_token do
        {:ok, _customer} = create_customer
        %Account{} = bind_account(_customer)
        {:ok, %Customer{}, _token} = auth_customer
      end

      @doc false
      def create_customer_and_authenticate_transfer do
        # acccount receive money
        {:ok, _customer} = create_customer(@create_attrs)
        bind_account(_customer)

        # account sender money
        {:ok, _customer} = create_customer(@create2_attrs)
        bind_account(_customer)
        {:ok, %Customer{}, _token} = auth_customer(@create2_attrs)
        {:ok, _customer} = get_user_by_token(_token)
      end

      @doc false
      def create_customer_and_authenticate_transfer_token do
        # acccount receive money
        {:ok, _customer} = create_customer(@create_attrs)
        bind_account(_customer)

        # account sender money
        {:ok, _customer} = create_customer(@create2_attrs)
        bind_account(_customer)
        {:ok, %Customer{}, _token} = auth_customer(@create2_attrs)
      end
    end
  end

  @docs false
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
        "period" => "23"
      }

      @monthly_attrs %{
        "filter" => "monthly",
        "type" => "",
        "period" => "04"
      }

      @yearly_attrs %{
        "filter" => "yerly",
        "type" => "",
        "period" => "2020"
      }

      @doc false
      def create_admin(attrs \\ @create_admin_attrs) do
        {:ok, admin} = Customers.create_customer(attrs)
      end

      @doc false
      def auth_admin(attrs \\ @create_admin_attrs) do
        {:ok, %Customer{}, _token} = Guardian.authenticate(attrs.email, attrs.password)
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
