import Config

# BankApi repo
config :bank_api, BankApi.Repo,
  database: "bank_api_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bank_api, ecto_repos: [BankApi.Repo]

# cowboy config
config :bank_api, cowboy_port: 4002

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, log_rounds: 4
