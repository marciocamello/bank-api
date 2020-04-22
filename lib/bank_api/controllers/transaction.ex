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
    Show total transactions
  """
  post "/report" do
    if Guardian.is_admin(conn) do

      %{
        "filter" => filter,
        "type" => type,
        "period" => period
      } = conn.body_params
  
      result = Transactions.filter_transactions(filter, type, period)
      Router.render_json(conn, %{message: "All transactions", result: result})
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
