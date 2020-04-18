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
      resource = Customers.get_customer(id)
      {:ok,  resource}
    end

    def resource_from_claims(_claims) do
      {:error, :reason_for_error}
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
  end