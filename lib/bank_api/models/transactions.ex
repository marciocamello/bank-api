defmodule BankApi.Models.Transactions do
  @moduledoc """
    Transactions model
  """
  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Schemas.Transaction
  alias BankApi.Models.Users
  alias BankApi.Models.Accounts
  alias BankApi.Auth.Guardian

  @doc """
    List all transactions

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> Transactions.list_transactions
      [ %BankApi.Schemas.Transaction{} ]
  """
  def list_transactions(query \\ Transaction) do
    Repo.all(query)
  end

  @doc """
    List all transactions and total

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> %{"filter" => filter,"type" => type,"period" => period} = %{"filter" => "","type" => "","period" => ""}
      iex> filter_transactions(filter, type, period)
      %{
        "total" => #Decimal<0.00>,
        "transactions" => [%BankApi.Schemas.Transaction{}]
      }
  """
  def filter_transactions(filter, type, period) do
    case filter do
      "" ->
        list_transactions
        |> filtered_params
      _ ->
          filter_period(filter, period, type)
          |> list_transactions
          |> filtered_params
    end
  end

  @doc false
  defp filter_period(filter, period, type) do
    %{"year" => year, "month" => month, "day" => day} = get_period(filter, period)
    %{"start_date" => start_date, "end_date" => end_date} = get_dates(filter, year, month, day)

    filtered_query(type, start_date, end_date)
  end

  @doc false
  defp get_period(filter, period) do
    year = DateTime.utc_now().year
    month = DateTime.utc_now().month
    day = DateTime.utc_now().month

    case filter do
      "daily" ->
        %{"year" => year, "month" => month, "day" => String.to_integer(period)}

      "monthly" ->
        %{"year" => year, "month" => String.to_integer(period), "day" => 01}

      "yearly" ->
        %{"year" => String.to_integer(period), "month" => month, "day" => 01}

      _ ->
        %{"year" => year, "month" => month, "day" => day}
    end
  end

  @doc false
  defp get_dates(filter, year, month, day) do
    start_date = NaiveDateTime.from_erl!({{year, month, day}, {00, 00, 00}})

    case filter do
      "daily" ->
        end_date = NaiveDateTime.from_erl!({{year, month, day}, {23, 59, 59}})
        %{"end_date" => end_date, "start_date" => start_date}

      _ ->
        days_in_month = Date.days_in_month(start_date)
        end_date = NaiveDateTime.from_erl!({{year, month, days_in_month}, {00, 00, 00}})
        %{"end_date" => end_date, "start_date" => start_date}
    end
  end

  @doc false
  defp filtered_params(transactions) do
    total = get_total_transactions(transactions)
    %{"transactions" => transactions, "total" => total}
  end

  @doc false
  defp filtered_query(type, start_date, end_date) do
    case type do
      "" ->
        from(t in Transaction, where: t.inserted_at >= ^start_date and t.inserted_at <= ^end_date)

      _ ->
        from(t in Transaction,
          where: t.inserted_at >= ^start_date and t.inserted_at <= ^end_date and t.type == ^type
        )
    end
  end

  @doc """
    Create transaction

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> Transactions.create_transaction(
        %{
          "value" => 10.00,
          "account_from" => "from@email.com",
          "account_to" => "to@email.com"
        }
      )
      { :ok, %BankApi.Schemas.Transaction{} }
  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Get total transactions with list

  # Examples
      iex> alias BankApi.Models.Transactions
      iex> Transactions.get_total_transactions([])
      iex> transaction = Transactions.get_total_transactions([
        %BankApi.Schemas.Transaction{
          account_from: "1@gmail.com",
          account_to: "1@gmail.com",
          id: 5,
          inserted_at: ~N[2020-04-22 02:21:49],
          type: "withdrawal",
          updated_at: ~N[2020-04-22 02:21:49],
          value: "10.00"
        }
      ])
      #Decimal<10.00>
  """
  def get_total_transactions(transactions) do
    Enum.map(transactions, fn tr -> Map.get(tr, :value) end)
    |> Enum.reduce(0, fn h, total -> Decimal.add(total, h) end)
  end
end
