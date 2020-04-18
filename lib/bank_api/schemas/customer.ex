defmodule BankApi.Schemas.Customer do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:firstName, :lastName, :email, :phone]}

  @doc false
  schema "customers" do
    field(:firstName, :string)
    field(:lastName, :string)
    field(:email, :string)
    field(:password, :string)
    field(:phone, :string)

    timestamps()
  end

  @doc false
  def changeset(struct, params) do
    struct
    |> cast(params, [:firstName, :lastName, :email, :password, :phone])
    |> validate_required([:firstName, :lastName, :email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9\._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/)
    |> unique_constraint([:email])
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  @doc false
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
