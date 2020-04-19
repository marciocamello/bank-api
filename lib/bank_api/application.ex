defmodule BankApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

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

  defp cowboy_port, do: Application.get_env(:bank_ai, :cowboy_port, 4000)
end
