import Config

# BankApi repo
config :bank_api,
   database: System.get_env("DB_DATABASE") || "bank_api",
   username: System.get_env("DB_USERNAME") || "postgres",
   password: System.get_env("DB_PASSWORD") || "postgres",
   hostname: System.get_env("DB_HOSTNAME") || "localhost"

# cowboy config
config :bank_api, cowboy_port: System.get_env("PORT") || 4001
