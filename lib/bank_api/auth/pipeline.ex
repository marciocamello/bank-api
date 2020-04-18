defmodule BankApi.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :bank_api,
    module: BankApi.Auth.Guardian,
    error_handler: BankApi.Auth.ErrorHandler

    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
end