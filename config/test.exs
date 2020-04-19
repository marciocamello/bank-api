import Config

# BankApi repo
config :bank_api, BankApi.Repo,
  database: "bank_api_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :bank_api, ecto_repos: [BankApi.Repo]

# cowboy config
config :bank_api, cowboy_port: 4000

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, log_rounds: 4

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bank_api, BankApi.Auth.Guardian,
  error_handler: BankApi.Auth.ErrorHandler,
  issuer: "bank_api",
  secret_key: "pSk7JYofPSxwMP0RZNNLccu2+DPJtHQLcIiK2Qk4RCK++imQoFAJTLz2WE0GpeJI"
