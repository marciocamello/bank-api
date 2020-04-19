defmodule BankApi.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias BankApi.Router

  @opts Router.init([])

  test "returns BankAPI V1 - Check docs to how to use" do
    conn =
      :get
      |> conn("/", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns Page not found" do
    conn =
      :get
      |> conn("/missing", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
