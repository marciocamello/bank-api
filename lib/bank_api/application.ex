defmodule BankApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @doc """
    Start application
  """
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: BankApi.Worker.start_link(arg)
      BankApi.Repo,
      {Plug.Cowboy, scheme: :http, plug: BankApi.Router, options: [port: cowboy_port()]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BankApi.Supervisor]

    Logger.info("Starting application...")
    Logger.info(Application.get_env(:bank_api, :message))

    Supervisor.start_link(children, opts)
  end

  @doc """
    Get cowboy port usin Mix.env and transform to integer
  """
  defp cowboy_port do
    port = Application.get_env(:bank_api, :cowboy_port, 4000)
    if is_bitstring(port) do
      String.to_integer(port)
    else
      port
    end
  end
end