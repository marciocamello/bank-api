defmodule BankApi.Fixtures do
  @moduledoc """
  A module for defining fixtures that can be used in tests.
  """
  
  def customer do

    alias BankApi.Models.Customers
    alias BankApi.Schemas.Customer
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

      @withdrawal_attrs %{
        "value" => 10.00,
        "password_confirm" => false
      }

      @withdrawal_confirm_attrs %{
        "value" => 10.00,
        "password_confirm" => @create_attrs.password
      }

      @doc false
      def create_customer do
        {:ok, customer} = Customers.create_customer(@create_attrs)
      end

      @doc false
      def bind_account(customer) do
        Customers.bind_account(customer)
      end

      @doc false
      def auth_customer do
        {:ok, %Customer{}, _token} =  Guardian.authenticate(@create_attrs.email, @create_attrs.password)
      end

      @doc false
      def get_customer(id) do
        Customers.get_customer(id)
      end

      @doc false
      def get_user_by_token(token) do
        {:ok, customer} = Guardian.get_user_by_token(token)
      end
    end
  end

  @doc """
  Apply the `fixtures`.
  """
  defmacro __using__(fixtures) when is_list(fixtures) do
    for fixture <- fixtures, is_atom(fixture),
      do: apply(__MODULE__, fixture, [])
  end
end