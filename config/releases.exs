import Config

# BankApi repo
config :bank_api,
   info: "BankApi Release",
   url: System.get_env("DATABASE_URL") || "postgres://postgres:postgres@bank-db:5432/bank_api",
   ssl: false

# cowboy config
config :bank_api, cowboy_port: System.get_env("PORT") || 4001
