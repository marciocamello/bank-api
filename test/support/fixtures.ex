defmodule BankApi.Fixtures do
  @moduledoc """
  A module for defining fixtures that can be used in tests.
  """

  @doc false
  def user do
    alias BankApi.Auth.Guardian
    alias BankApi.Models.Users
    alias BankApi.Schemas.Account
    alias BankApi.Schemas.User

    quote do
      @create_attrs %{
        email: "test@email.com",
        firstName: "Test",
        lastName: "Marcio",
        phone: "37 98406 2829",
        password: "123123123"
      }

      @create2_attrs %{
        email: "tes2t@email.com",
        firstName: "Test2",
        lastName: "Andre",
        phone: "37 98406 2829",
        password: "123123123"
      }

      @update_attrs %{
        email: "test_update@email.com",
        firstName: "Test Update",
        lastName: "Marcio Jose",
        phone: "37 98406 2829",
        password: "123123123"
      }

      @withdrawal_attrs %{
        "value" => "10.00",
        "password_confirm" => false
      }

      @withdrawal_confirm_attrs %{
        "value" => "10.00",
        "password_confirm" => @create_attrs.password
      }

      @transfer_attrs %{
        "account_to" => @create_attrs.email,
        "value" => "10.00",
        "password_confirm" => false
      }

      @transfer_confirm_attrs %{
        "account_to" => @create_attrs.email,
        "value" => "10.00",
        "password_confirm" => @create_attrs.password
      }

      @doc false
      def create_user(attrs \\ @create_attrs) do
        {:ok, user} = Users.create_user(attrs)
      end

      @doc false
      def bind_account(user) do
        Users.bind_account(user)
      end

      @doc false
      def auth(attrs \\ @create_attrs) do
        Guardian.authenticate(attrs.email, attrs.password)
      end

      @doc false
      def auth_user(attrs \\ @create_attrs) do
        {:ok, user, token} = auth()
      end

      @doc false
      def get_user(id) do
        Users.get_user(id)
      end

      @doc false
      def get_user_by_token(token) do
        {:ok, user} = Guardian.get_user_by_token(token)
      end

      @doc false
      def create_users do
        {:ok, user} =
          Users.create_user(
            %{
              email: Faker.Internet.email(),
              firstName: Faker.Name.PtBr.name(),
              lastName: Faker.Name.PtBr.name(),
              password: "123123123",
              phone: Faker.Phone.EnUs.phone()
            }
          )

        Users.bind_account(user)
      end

      @doc false
      def seed_users(count) do
        for n <- 1..count do
          create_users()
        end
      end

      @doc false
      def create_user_and_token do
        {:ok, user} = create_user()
        bind_account(user)
        {:ok, user, token} = auth_user()
      end

      @doc false
      def create_user_and_authenticate do
        {:ok, user} = create_user()
        bind_account(user)
        {:ok, user, token} = auth_user()
        {:ok, user} = get_user_by_token(token)
      end

      @doc false
      def create_user_and_authenticate_token do
        {:ok, user} = create_user()
        bind_account(user)
        {:ok, user, token} = auth_user()
      end

      @doc false
      def create_user_and_authenticate_transfer do
        # acccount receive money
        {:ok, user} = create_user(@create_attrs)
        bind_account(user)

        # account sender money
        {:ok, user} = create_user(@create2_attrs)
        bind_account(user)
        {:ok, user, token} = auth_user(@create2_attrs)
        {:ok, user} = get_user_by_token(token)
      end

      @doc false
      def create_user_and_authenticate_transfer_token do
        # acccount receive money
        {:ok, user} = create_user(@create_attrs)
        bind_account(user)

        # account sender money
        {:ok, user} = create_user(@create2_attrs)
        bind_account(user)
        {:ok, user, token} = auth_user(@create2_attrs)
      end
    end
  end

  @doc false
  def transaction do
    alias BankApi.Models.Users
    alias BankApi.Models.Transactions
    alias BankApi.Schemas.User
    alias BankApi.Schemas.Transaction
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
        "period" => Date.utc_today().day
                    |> Integer.to_string()
      }

      @monthly_attrs %{
        "filter" => "monthly",
        "type" => "",
        "period" => Date.utc_today().month
                    |> Integer.to_string()
      }

      @yearly_attrs %{
        "filter" => "yearly",
        "type" => "",
        "period" => Date.utc_today().year
                    |> Integer.to_string()
      }

      @doc false
      def create_admin(attrs \\ @create_admin_attrs) do
        {:ok, admin} = Users.create_user(attrs)
      end

      @doc false
      def auth_admin(attrs \\ @create_admin_attrs) do
        {:ok, user, token} = Guardian.authenticate(attrs.email, attrs.password)
      end

      @doc false
      def withdrawal(count, type) do
        for n <- 1..count do
          date = Faker.DateTime.between(~N[2019-05-05 00:00:00], ~N[2020-05-05 00:00:00])

          transaction = %{
            value: Enum.random(10..500) |> Integer.to_string,
            account_from: Faker.Internet.email(),
            account_to: Faker.Internet.email(),
            type: type,
            inserted_at:  date,
            updated_at:  date,
          }
        end
      end

      @doc false
      def seed_withdrawal(count) do
        withdrawal(count, "withdrawal")
        |> Enum.map(fn transaction -> Transactions.insert_transaction(transaction) end)
      end

      @doc false
      def seed_transfers(count) do
        withdrawal(count, "transfer")
        |> Enum.map(fn transaction -> Transactions.insert_transaction(transaction) end)
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
