defmodule BankApi.Controllers.Auth do
    @moduledoc false
    use Plug.Router
    alias BankApi.Router
    alias BankApi.Helpers.TranslateError
    alias BankApi.Models.Customers
    alias BankApi.Auth.Guardian

    plug(:match)
    plug(:dispatch)
  
    @doc """
    Get Access Token
    """
    post "/" do
        %{"email" => email, "password" => password} = conn.body_params

        case Guardian.authenticate(email, password) do
            {:ok, customer, token} ->
                Router.render_json(conn, %{message: "Login success!", customer: customer, token: token})
            {:error, :unauthorized} ->
                Router.render_json(conn, %{errors: "Invalid credentials"})
        end
    end
end