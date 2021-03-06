defmodule BankApi.Controllers.Transaction do
  @moduledoc """
    Transaction Controller context
  """
  use Plug.Router
  alias BankApi.Repo
  alias BankApi.Auth.Guardian
  alias BankApi.Models.Transactions
  alias BankApi.Router

  plug(:match)
  plug(BankApi.Auth.Pipeline)
  plug(:dispatch)

  @doc """
    Show transactions reports
  """
  post "/report" do
    token = Router.get_bearer_token(conn)

    if Guardian.is_admin(token) do
      %{
        "filter" => filter,
        "type" => type,
        "period" => period
      } = conn.body_params

      result = Transactions.filter_transactions(filter, type, period)

      filter =
        if filter == "" do
          "All"
        else
          String.capitalize(filter)
        end

      Router.render_json(conn, %{
        message: filter <> " transactions",
        result: result
      })
    else
      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Default route to page not found
  """
  match _ do
    Router.render_json(conn, %{message: "Page not found"}, 404)
  end
end
