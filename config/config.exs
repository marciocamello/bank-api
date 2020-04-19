Copy
use Mix.Config

# Default mensage
config :bank_api,
  message_one: "BankApi config environments"

import_config "#{Mix.env}.exs"