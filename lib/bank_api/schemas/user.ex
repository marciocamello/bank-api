defmodule BankApi.Schemas.User do
  @moduledoc """
    User scheme context
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :firstName, :lastName, :email, :phone, :accounts, :acl]}

  @doc """
    Table schema
  """
  schema "users" do
    field(:firstName, :string)
    field(:lastName, :string)
    field(:email, :string)
    field(:password, :string)
    field(:phone, :string)
    field(:acl, :string, default: "user")
    has_one(:accounts, BankApi.Schemas.Account)

    timestamps()
  end

  @doc """
    Changeset implements 
    Validate required fields
    Validate email format
    Validate unique email
    Validate password length min 6
    Create password hash
  """
  def changeset(struct, params) do
    struct
    |> cast(params, [:firstName, :lastName, :email, :password, :phone, :acl])
    |> validate_required([:firstName, :lastName, :email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9\._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/)
    |> unique_constraint([:email])
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  @doc """
    Encrypt password
  """
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
