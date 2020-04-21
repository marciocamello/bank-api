defmodule BankApi.Models.Accounts do
  @moduledoc """
    Accounts model
  """
  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Schemas.Account

  @doc """
    Update account

  # Examples
      iex> alias BankApi.Models.Accounts
  """
  def update_account(%Account{} = account, attrs, apply \\ false) do
    case apply do
      true ->
        account
        |> Account.changeset(attrs)
        |> Repo.update()
      false ->
        account = account
        |> Account.changeset(attrs)
        {:ok, account.data}
    end
  end
end
