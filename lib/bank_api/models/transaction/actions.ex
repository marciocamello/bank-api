defmodule BankApi.Models.Transactions.Action do
  @moduledoc """
    Transactions actions
  """
  alias BankApi.Models.Transactions
  alias BankApi.Models.Users
  alias BankApi.Models.Accounts
  alias BankApi.Auth.Guardian

  @doc """
    Withdrawal money from user account

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> params = %{"account" => "teste@email.com", "value" => 100.00} 
      iex> Transactions.withdrawal(params)
      {:ok, %BankApi.Schemas.Account{}}
  """
  def withdrawal(params) do
    %{
      "user" => user,
      "value" => value,
      "password_confirm" => password_confirm
    } = params

    # check value is less then 0.00
    with {:ok, value} <- check_value(value) do
      # udate balance from accounts and a request value
      case update_balance(user.accounts.balance, value) do
        {:ok, new_balance} ->
          # check password confirmation before finish operation
          case password_confirmation(user, password_confirm) do
            {:error, :unauthorized} ->
              {:error, :unauthorized}

            {:info, :wait_confirmation} ->
              {:info, _account} =
                Accounts.update_balance(
                  user.accounts,
                  %{"balance" => new_balance}
                )

            {:ok, :confirmed} ->
              # create transaction
              Transactions.create_transaction(%{
                "value" => value,
                "account_from" => user.email,
                "account_to" => user.email,
                "type" => "withdrawal"
              })

              {:ok, account} =
                Accounts.update_balance(
                  user.accounts,
                  %{"balance" => new_balance},
                  true
                )
          end

        {:error, :not_funds} ->
          {:error, :not_funds}
      end
    end
  end

  @doc """
    Transfer money from user
    account to other user account

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> alias BankApi.Models.Users
      iex> params = %{"account" => "teste@email.com", "value" => 100.00}
      iex> {:ok, user} = Users.get_by_email(account)
      iex> params = conn.body_params
        |> Map.put("user", user)
      iex> Transactions.transfer(params)
      {:ok, %BankApi.Schemas.Account{}}
  """
  def transfer(params) do
    %{
      "user" => user,
      "account_to" => account_to,
      "value" => value,
      "password_confirm" => password_confirm
    } = params

    # check value is less then 0.00
    with {:ok, value} <- check_value(value) do
      # check account to transfer by email
      with {:ok, account_to} <- Users.get_by_email(account_to) do
        # udate balance from accounts and a request value and to request
        case update_balance(user.accounts.balance, account_to.accounts.balance, value) do
          {:ok, new_balance} ->
            # get balance from sender and balance from receiver accounts
            %{"new_from_balance" => new_from_balance, "new_to_balance" => new_to_balance} =
              new_balance

            # check password confirmation before finish operation
            case password_confirmation(user, password_confirm) do
              {:error, :unauthorized} ->
                {:error, :unauthorized}

              {:info, :wait_confirmation} ->
                {:info, _account} =
                  Accounts.update_balance(
                    user.accounts,
                    account_to.accounts,
                    %{"balance" => new_from_balance},
                    %{"balance" => new_to_balance}
                  )

              {:ok, :confirmed} ->
                # create transaction
                Transactions.create_transaction(%{
                  "value" => value,
                  "account_from" => user.email,
                  "account_to" => account_to.email,
                  "type" => "transfer"
                })

                {:ok, account} =
                  Accounts.update_balance(
                    user.accounts,
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
  end

  @doc false
  defp check_value(value) do
    case Decimal.equal?(Decimal.from_float(value), 0) do
      true ->
        {:error, :zero_value}

      false ->
        {:ok, value}
    end
  end

  @doc false
  defp password_confirmation(user, password_confirm \\ false) do
    if password_confirm do
      case Guardian.validate_password(password_confirm, user.password) do
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
    new_balance = sub_balance(balance, value)

    case Decimal.negative?(new_balance) do
      true ->
        {:error, :not_funds}

      false ->
        {:ok, new_balance}
    end
  end

  @doc false
  defp update_balance(from_balance, to_balance, value) do
    new_from_balance = sub_balance(from_balance, value)
    new_to_balance = add_balance(to_balance, value)

    case Decimal.negative?(new_from_balance) do
      true ->
        {:error, :not_funds}

      false ->
        {:ok,
         %{
           "new_from_balance" => new_from_balance,
           "new_to_balance" => new_to_balance
         }}
    end
  end

  @doc false
  defp add_balance(balance, value) do
    balance
    |> Decimal.add(Decimal.from_float(value))
  end

  @doc false
  defp sub_balance(balance, value) do
    balance
    |> Decimal.sub(Decimal.from_float(value))
  end
end
