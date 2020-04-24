defmodule BankApi.CLI.Utils do
  @moduledoc """
    Utils functions to project
  """

  @doc """
    Get cowboy port usin Mix.env and transform to integer
    iex> alias BankApi.CLI.Utils
    iex> Utils.cowboy_port("8000")
  """
  def cowboy_port(port \\ Application.get_env(:bank_api, :cowboy_port, 4000)) do
    if is_bitstring(port) do
      String.to_integer(port)
    else
      port
    end
  end
end
