defmodule BankApi.Controllers.Auth do
    @moduledoc false
    use Plug.Router
    alias BankApi.Auth.Guardian
    alias BankApi.Router

    plug(:match)
    plug(:dispatch)
  
    @doc """
    User login and get access token
    """
    post "/login" do
        %{"email" => email, "password" => password} = conn.body_params

        case Guardian.authenticate(email, password) do
            {:ok, customer, token} ->
                Router.render_json(conn, %{message: "Login success!", customer: customer, token: token})
            {:error, :unauthorized} ->
                Router.render_json(conn, %{errors: "Invalid credentials"})
        end
    end
end