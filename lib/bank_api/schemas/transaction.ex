defmodule BankApi.Schemas.Transaction do
  @moduledoc """
    Transaction scheme context
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:account_from, :account_to, :value]}

  @doc """
    Table schema
  """
  schema "transactions" do
    field(:value, :decimal)
    field(:account_from, :string)
    field(:account_to, :string)

    timestamps()
  end

  @doc """
    Changeset implements 
    Validate required fields
  """
  def changeset(struct, params) do
    struct
    |> cast(params, [:account_from, :account_to, :value])
    |> validate_required([:account_from, :account_to, :value])
  end
end
