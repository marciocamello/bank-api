use Mix.Config

# Environment message
config :bank_api,
  message: "Production"

# BankApi repo
config :bank_api, BankApi.Repo,
  database: "d9of25tamfl64u",
  username: "evfcuapfqxggne",
  password: "2dcddc7954cf99f33aa80c1e28c435c91d04a0e0fc0b628518c84f1696f723b3",
  hostname: "ec2-18-233-137-77.compute-1.amazonaws.com"

config :bank_api, ecto_repos: [BankApi.Repo]

# cowboy config
config :bank_api, cowboy_port: System.get_env("PORT")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bank_api, BankApi.Auth.Guardian,
  error_handler: BankApi.Auth.ErrorHandler,
  issuer: "bank_api",
  secret_key: "pSk7JYofPSxwMP0RZNNLccu2+DPJtHQLcIiK2Qk4RCK++imQoFAJTLz2WE0GpeJI"
