use Mix.Config

# Environment message
config :bank_api,
       message: "Development"

# BankApi repo
config :bank_api,
       BankApi.Repo,
       database: System.get_env("DB_DATABASE") || "bank_api_repo",
       username: System.get_env("DB_USERNAME") || "postgres",
       password: System.get_env("DB_PASSWORD") || "postgres",
       hostname: System.get_env("DB_HOSTNAME") || "bank-db",
       show_sensitive_data_on_connection_error: true

config :bank_api, ecto_repos: [BankApi.Repo]

# cowboy config
config :bank_api, cowboy_port: 4000

# Configures Elixir's Logger
config :logger,
       :console,
       format: "$time $metadata[$level] $message\n",
       metadata: [:request_id]

config :bank_api,
       BankApi.Auth.Guardian,
       error_handler: BankApi.Auth.ErrorHandler,
       issuer: "bank_api",
       secret_key: "pSk7JYofPSxwMP0RZNNLccu2+DPJtHQLcIiK2Qk4RCK++imQoFAJTLz2WE0GpeJI"
