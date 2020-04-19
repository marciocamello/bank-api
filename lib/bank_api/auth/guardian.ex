defmodule BankApi.Auth.Guardian do
  @moduledoc """
    Guardian methods to authentication
  """
  use Guardian, otp_app: :bank_api

  alias BankApi.Models.Customers

  @doc """
    Callback implementation for Guardian.subject_for_token/2.  
  """
  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  @doc """
    sYou can use any value for the subject of your token but
    it should be useful in retrieving the resource later, see
    how it being used on `resource_from_claims/1` function.
    A unique `id` is a good subject, a non-unique email address
    is a poor subject.
  """
  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  @doc """
    Here we'll look up our resource from the claims, the subject can be
    found in the `"sub"` key. In `above subject_for_token/2` we returned
    the resource id so here we'll rely on that to look it up.
  """
  def resource_from_claims(claims) do
    id = claims["sub"]

    case Customers.get_customer(id) do
      nil ->
        {:error, :reason_for_error}

      resource ->
        {:ok, resource}
    end
  end

  @doc """
    Authenticate customer by email and password
    Check encrypted password and your database hash
    Create a new token and add to esponse
  """
  def authenticate(email, password) do
    with {:ok, customer} <- Customers.get_by_email(email) do
      case validate_password(password, customer.password) do
        true ->
          create_token(customer)

        false ->
          {:error, :unauthorized}
      end
    end
  end

  @doc """
    Validate password encrypted to database hash
  """
  defp validate_password(password, encrypted_password) do
    Bcrypt.verify_pass(password, encrypted_password)
  end

  @doc """
    Create JWT token from Guardin encode and sign
  """
  defp create_token(customer) do
    {:ok, token, _claims} = encode_and_sign(customer)
    {:ok, customer, token}
  end

  @doc """
    Terminar customer account and remove from database
  """
  def terminate_account(token) do
    {:ok, %{"id" => id}} = decode_and_verify(token)

    case Customers.get_customer(id) do
      nil ->
        IO.puts("Error")

      customer ->
        Customers.delete_customer(customer)
    end
  end
end