defmodule BankApiTest do
  use ExUnit.Case
  doctest BankApi

  test "greets the world" do
    assert BankApi.hello() == :world
  end
end
