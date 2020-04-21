defmodule BankApi.Models.Transactions do
  @moduledoc """
    Transactions model
  """
  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Schemas.Transaction
  alias BankApi.Models.Customers
  alias BankApi.Models.Accounts

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
        case Accounts.update_account(customer.accounts, %{"balance" => new_balance}) do
          {:ok, account} ->
            {:ok, account}
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
    %{"account_from" => account_from, "account_to" => account_to, "value" => value} = params
    with {:ok, account_to} <- Customers.get_by_email(account_to) do
      account = %{"account_from" => account_from, "account_to" => account_to}
      {:ok, account}
    end
  end

  @doc false
  defp password_confirmation(customer, password_confirm) do
    case password_confirm do
      false -> {:info, :wait_confirmation}
      true -> {:ok, :confirmed}
    end
  end

  @doc false
  defp preview_updated_account(customer, new_balance) do
    {:info, %{}} = Map.update(customer.accounts, "balance", new_balance, &(&1 * 2))
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
end
