defmodule BankApi.Auth.Guardian do
    use Guardian, otp_app: :bank_api

    alias BankApi.Models.Customers
  
    def subject_for_token(resource, _claims) do
      sub = to_string(resource.id)
      {:ok, sub}
    end

    def subject_for_token(_, _) do
      {:error, :reason_for_error}
    end
  
    def resource_from_claims(claims) do
      id = claims["sub"]
      case Customers.get_customer(id) do
        nil ->
          {:error, :reason_for_error}
        resource ->
          {:ok, resource}
      end
    end

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
  
    defp validate_password(password, encrypted_password) do
      Bcrypt.verify_pass(password, encrypted_password)
    end
  
    defp create_token(customer) do
      {:ok, token, _claims} = encode_and_sign(customer)
      {:ok, customer, token}
    end

    def terminate_account(token) do
      {:ok, %{"id" => id}} = decode_and_verify(token)
      case Customers.get_customer(id) do
        nil ->
          IO.puts "Error"
        customer ->
          Customers.delete_customer(customer)
      end
    end
  end