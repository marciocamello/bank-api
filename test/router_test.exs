defmodule BankApi.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias BankApi.Router

  @opts Router.init([])

  test "returns ping route" do
    conn =
      :get
      |> conn("/ping", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns welcome" do
    conn =
      :get
      |> conn("/", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns 404" do
    conn =
      :get
      |> conn("/missing", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
