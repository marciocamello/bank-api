defmodule BankApi.Models.Transactions do
  @moduledoc """
    Transactions model
  """
  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Schemas.Transaction
  alias BankApi.Models.Customers
  alias BankApi.Models.Accounts
  alias BankApi.Auth.Guardian

  @doc """
    Withdrawal money from customer account

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> params = %{"account" => "teste@email.com", "value" => 100.00} 
      iex> Transactions.withdrawal(params)
      {:ok, %BankApi.Schemas.Account{}}
  """
  def withdrawal(params) do
    %{
      "customer" => customer,
      "value" => value,
      "password_confirm" => password_confirm
    } = params

    case update_balance(customer.accounts.balance, value) do
      {:ok, new_balance} ->
        case password_confirmation(customer, password_confirm) do
          {:error, :unauthorized} -> {:error, :unauthorized}
          {:info, :wait_confirmation} ->
            {:info, _account} = Accounts.update_balance(
              customer.accounts,
              %{"balance" => new_balance
            })
          {:ok, :confirmed} ->
            {:ok, account} = Accounts.update_balance(
              customer.accounts,
              %{"balance" => new_balance},
              true
            )
        end
      {:error, :not_funds} ->
        {:error, :not_funds}
    end
  end

  @doc """
    Transfer money from customer 
    account to other customer account

  # Examples
      iex> alias BankApi.Models.Transactions
  """
  def transfer(params) do
    %{
      "customer" => customer,
      "account_to" => account_to,
      "value" => value,
      "password_confirm" => password_confirm
    } = params

    with {:ok, account_to} <- Customers.get_by_email(account_to) do
      case update_balance(customer.accounts.balance, account_to.accounts.balance, value) do
        {:ok, new_balance} ->
          %{"new_from_balance" => new_from_balance, "new_to_balance" => new_to_balance} = new_balance
          case password_confirmation(customer, password_confirm) do
            {:error, :unauthorized} -> {:error, :unauthorized}
            {:info, :wait_confirmation} ->
              {:info, _account} = Accounts.update_balance(
                customer.accounts,
                account_to.accounts,
                %{"balance" => new_from_balance},
                %{"balance" => new_to_balance}
              )
            {:ok, :confirmed} ->
              {:ok, account} = Accounts.update_balance(
                customer.accounts,
                account_to.accounts,
                %{"balance" => new_from_balance},
                %{"balance" => new_to_balance},
                true
              )
          end
        {:error, :not_funds} ->
          {:error, :not_funds}
      end
    end
  end

  @doc false
  def password_confirmation(customer, password_confirm \\ false) do
    if password_confirm do
      case Guardian.validate_password(password_confirm, customer.password) do
        true ->
          {:ok, :confirmed}
        false ->
          {:error, :unauthorized}
      end
    else
      {:info, :wait_confirmation}
    end
  end

  @doc false
  defp update_balance(balance, value) do
    new_balance = balance
      |> Decimal.sub(Decimal.from_float(value))

    case Decimal.negative?(new_balance) do
      true ->
        {:error, :not_funds}
      false ->
        {:ok, new_balance}
    end
  end

  @doc false
  defp update_balance(from_balance, to_balance, value) do
    new_from_balance = from_balance
      |> Decimal.sub(Decimal.from_float(value))

    new_to_balance = to_balance
      |> Decimal.add(Decimal.from_float(value))

    case Decimal.negative?(new_from_balance) do
      true ->
        {:error, :not_funds}
      false ->
        {:ok, %{
          "new_from_balance" => new_from_balance,
          "new_to_balance" => new_to_balance
        }}
    end
  end
end
