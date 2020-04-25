defmodule BankApi.Repo do
  use Ecto.Repo,
    otp_app: :bank_api,
    adapter: Ecto.Adapters.Postgres
end

defmodule BankApi.Repo do
  @moduledoc false
  @doc false
  use Ecto.Repo,
    otp_app: :bank_api,
    adapter: Ecto.Adapters.Postgres

  @spec truncate(Ecto.Schema.t()) :: :ok
  def truncate(schema) do
    table_name = schema.__schema__(:source)
    query("TRUNCATE #{table_name}", [])
    :ok
  end
end
