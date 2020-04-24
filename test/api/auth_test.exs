defmodule BankApi.RouteAuthTest do
  use ExUnit.Case
  use Plug.Test

  alias BankApi.Router

  @opts Router.init([])

  # page not found
  test "returns Page not found" do
    conn =
      :get
      |> conn("/api/auth", "")
      |> Router.call(@opts)

    assert conn.status == 404
    assert %{"message" => "Page not found"} = Jason.decode!(conn.resp_body)
  end
end
