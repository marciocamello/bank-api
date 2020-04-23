use Mix.Config

# Environment message
config :bank_api,
  message: "Development"

# BankApi repo
config :bank_api, BankApi.Repo,
  database: "bank_api_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost" # docker container bank-db-api

config :bank_api, ecto_repos: [BankApi.Repo]

# cowboy config
config :bank_api, cowboy_port: 4000

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bank_api, BankApi.Auth.Guardian,
  error_handler: BankApi.Auth.ErrorHandler,
  issuer: "bank_api",
  secret_key: "pSk7JYofPSxwMP0RZNNLccu2+DPJtHQLcIiK2Qk4RCK++imQoFAJTLz2WE0GpeJI"