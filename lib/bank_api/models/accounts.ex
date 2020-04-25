defmodule BankApi.Models.Accounts do
  @moduledoc """
    Accounts model
  """
  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Schemas.Account

  @doc """
    Update current account balance

  # Examples
      iex> alias BankApi.Models.Accounts
  """
  def update_balance(%Account{} = account, attrs, apply \\ false) do
    case apply do
      true ->
        account
        |> Account.changeset(attrs)
        |> Repo.update()

      false ->
        account =
          account
          |> Account.changeset(attrs)

        {:info,
         %{
           email: account.data.user.email,
           old_balance: account.data.balance,
           new_balance: account.changes.balance
         }}
    end
  end

  @doc """
    Update transfer operation to user account

  # Examples
      iex> alias BankApi.Models.Accounts
  """
  def update_balance(%Account{} = from, %Account{} = to, from_attrs, to_attrs, apply \\ false) do
    case apply do
      true ->
        from
        |> Account.changeset(from_attrs)
        |> Repo.update()

        to
        |> Account.changeset(to_attrs)
        |> Repo.update()

      false ->
        from =
          from
          |> Account.changeset(from_attrs)

        to =
          to
          |> Account.changeset(to_attrs)

        {:info,
         %{
           from: %{
             email: from.data.user.email,
             old_balance: from.data.balance,
             new_balance: from.changes.balance
           },
           to: %{
             email: to.data.user.email,
             old_balance: to.data.balance,
             new_balance: to.changes.balance
           }
         }}
    end
  end
end
