import Config

# BankApi repo
config :bank_api, BankApi.Repo,
  database: "bank_api_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :bank_api, ecto_repos: [BankApi.Repo]

# cowboy config
config :bank_api, cowboy_port: 4000

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
