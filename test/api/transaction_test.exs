defmodule BankApi.Api.TranbsactionTest do
  use BankApi.AppCase, assync: true
  use Plug.Test
  doctest BankApi

  alias BankApi.Router

  # global fixtures
  use BankApi.Fixtures, [:user, :transaction]

  @opts Router.init([])

  # Descript api tests
  describe "transactions" do
    # page not found
    test "returns Page not found" do
      create_admin()
      {:ok, _, token} = auth_admin()

      conn =
        :get
        |> conn("/api/transactions/missing")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 404
      assert %{"message" => "Page not found"} = Jason.decode!(conn.resp_body)
    end

    # users failed
    test "GET transactions failed" do
      {:ok, _, token} = create_user_and_token()

      conn =
        :post
        |> conn("/api/transactions/report", @all_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # list all transactions
    test "GET transactions/report" do
      create_admin()
      {:ok, _, token} = auth_admin()

      conn =
        :post
        |> conn("/api/transactions/report", @all_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200

      assert %{"message" => "All transactions", "result" => %{"total" => 0, "transactions" => []}} =
               Jason.decode!(conn.resp_body)
    end

    # list daily transactions
    test "GET transactions/report daily" do
      create_admin()
      {:ok, _, token} = auth_admin()

      conn =
        :post
        |> conn("/api/transactions/report", @daily_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200

      assert %{
               "message" => "Daily transactions",
               "result" => %{"total" => 0, "transactions" => []}
             } = Jason.decode!(conn.resp_body)
    end

    # list monthly transactions
    test "GET transactions/report monthly" do
      create_admin()
      {:ok, _, token} = auth_admin()

      conn =
        :post
        |> conn("/api/transactions/report", @monthly_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200

      assert %{
               "message" => "Monthly transactions",
               "result" => %{"total" => 0, "transactions" => []}
             } = Jason.decode!(conn.resp_body)
    end

    # list yearly transactions
    test "GET transactions/report yearly" do
      create_admin()
      {:ok, _, token} = auth_admin()

      conn =
        :post
        |> conn("/api/transactions/report", @yearly_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200

      assert %{
               "message" => "Yearly transactions",
               "result" => %{"total" => 0, "transactions" => []}
             } = Jason.decode!(conn.resp_body)
    end

    # list withdrawal transactions
    test "GET transactions/report withdrawal" do
      create_admin()
      {:ok, _, token} = auth_admin()

      params =
        @yearly_attrs
        |> Map.put("type", "withdrawal")

      conn =
        :post
        |> conn("/api/transactions/report", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200

      assert %{
               "message" => "Yearly transactions",
               "result" => %{"total" => 0, "transactions" => []}
             } = Jason.decode!(conn.resp_body)
    end

    # list transfer transactions
    test "GET transactions/report transfer" do
      create_admin()
      {:ok, _, token} = auth_admin()

      params =
        @yearly_attrs
        |> Map.put("type", "transfer")

      conn =
        :post
        |> conn("/api/transactions/report", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200

      assert %{
               "message" => "Yearly transactions",
               "result" => %{"total" => 0, "transactions" => []}
             } = Jason.decode!(conn.resp_body)
    end
  end
end
