import Config

# BankApi repo
config :bank_api,
       database: System.get_env("DB_DATABASE"),
       username: System.get_env("DB_USERNAME"),
       password: System.get_env("DB_PASSWORD"),
       hostname: System.get_env("DB_HOSTNAME"),
       ssl: true

# cowboy config
config :bank_api, cowboy_port: System.get_env("PORT") || 4001
