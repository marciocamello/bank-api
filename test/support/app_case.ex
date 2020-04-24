defmodule BankApi.AppCase do
  @moduledoc """
    This module defines the test case to be used by
    BankApi tests.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      alias BankApi.Repo
      alias BankApi.Models.Customers
      alias BankApi.Models.Transactions
      alias BankApi.Schemas.Customer
      alias BankApi.Schemas.Account
      alias BankApi.Auth.Guardian
      alias BankApi.Helpers.TranslateError

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import BankApi.AppCase
    end
  end

  # sandbox sql setup
  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BankApi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(BankApi.Repo, {:shared, self()})
    end

    :ok
  end
end
