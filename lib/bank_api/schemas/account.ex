defmodule BankApi.Schemas.Account do
  @moduledoc """
    Account scheme context
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:balance]}

  @doc """
    Table schema
  """
  schema "accounts" do
    field(:balance, :decimal, default: 1000)
    belongs_to :customer, BankApi.Schemas.Customer

    timestamps()
  end

  @doc """
    Changeset implements 
    Validate required fields
  """
  def changeset(struct, params) do
    struct
    |> cast(params, [:balance])
    |> validate_required([:balance])
  end
end
