use Mix.Config

# Environment message
config :bank_api,
       message: "Production"

# BankApi repo
config :bank_api,
       BankApi.Repo,
       adapter: Ecto.Adapters.Postgres,
       url: "postgres://cnlairxqwucnqq:94f93233b5a47e51bffd7bf7f72c13156ee7d72705a20ccc24ba22454a227f20@ec2-54-81-37-115.compute-1.amazonaws.com:5432/dcq2aksoqjive5",
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
