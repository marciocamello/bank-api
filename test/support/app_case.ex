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
    end
  end
end
