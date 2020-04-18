defmodule BankApi.Plugs.RequireAuth do
  @moduledoc """

  """
  import Plug.Conn
  alias BankApi.Router

  @doc """

  """
  def init(params) do
  end

  @doc """

  """
  def call(conn, _params) do
    token = ""
    case BankApi.Auth.Guardian.decode_and_verify(token) do
      {:ok, %{}} ->
        conn
      {:error, %{}} ->
        data = %{message: "Youn can't authorization access this route"}
        conn
        |> send_resp(401, Jason.encode!(data))
        |> halt()
    end
  end
end
