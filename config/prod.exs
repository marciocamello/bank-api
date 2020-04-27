use Mix.Config

# Environment message
config :bank_api,
       message: "Production"

# BankApi repo
config :bank_api,
       BankApi.Repo,
       adapter: Ecto.Adapters.Postgres,
       show_sensitive_data_on_connection_error: true,
       pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5"),
       url: System.get_env("DATABASE_URL"),
       database: false,
       ssl: true

config :bank_api, ecto_repos: [BankApi.Repo]

# cowboy config
config :bank_api, cowboy_port: System.get_env("PORT")

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
