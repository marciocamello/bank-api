defmodule BankApi.Controllers.Home do
    @moduledoc """
    This is a Home Controller
    """
    alias BankApi.Router
  
    @doc """
    Home index route
    """
    def index(conn) do

        Router.render_json(conn, %{message: "BankAPI V1 - Check docs to how to use"})
    end
end