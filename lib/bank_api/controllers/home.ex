defmodule BankApi.Controllers.Home do
  @moduledoc """
    Home Controller context
  """
  use Plug.Router
  alias BankApi.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  @doc """
    Home index route
  """
  get "/" do
    Router.render_json(conn, %{message: "BankAPI V1 - Check docs to how to use"})
  end
end
