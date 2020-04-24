defmodule BankApi.Api.CustomerTest do
  use BankApi.AppCase, assync: true
  use Plug.Test
  doctest BankApi

  alias BankApi.Router

  # global fixtures
  use BankApi.Fixtures, [:customer, :transaction]

  @opts Router.init([])

  # Descript api tests
  describe "customers" do
    # unauthorized user
    test "GET customers unauthorized user" do
      conn =
        :get
        |> conn("/api/customers")
        |> Router.call(@opts)

      assert conn.status == 401
    end

    # customers failed
    test "GET customers failed" do
      {:ok, %Customer{}, token} = create_customer_and_token()

      conn =
        :get
        |> conn("/api/customers")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # list all customers
    test "GET customers list" do
      create_admin()
      {:ok, %Customer{}, token} = auth_admin()

      conn =
        :get
        |> conn("/api/customers")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "Customer listed with success!"} = Jason.decode!(conn.resp_body)
    end

    # create customer failed
    test "POST customers create failed" do
      create_admin()
      {:ok, %Customer{}, token} = auth_admin()

      conn =
        :post
        |> conn("/api/customers", %{
          "customer" => %{}
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => _changeset} = Jason.decode!(conn.resp_body)
    end

    # create customer unauthorized
    test "POST customers create unauthorized" do
      {:ok, %Customer{}, token} = create_customer_and_token()

      conn =
        :post
        |> conn("/api/customers", %{
          "customer" => %{}
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # create customer
    test "POST customers create" do
      create_admin()
      {:ok, %Customer{}, token} = auth_admin()

      conn =
        :post
        |> conn("/api/customers", %{
          "customer" => @create_attrs
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "Customer created with success!"} = Jason.decode!(conn.resp_body)
    end

    # show customer unauthorized
    test "GET customers show unauthorized" do
      {:ok, customer, token} = create_customer_and_token()

      conn =
        :get
        |> conn("/api/customers/#{customer.id}")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # show customer not found
    test "GET customers show not found" do
      create_admin()
      {:ok, %Customer{}, token} = auth_admin()

      conn =
        :get
        |> conn("/api/customers/100")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "This customer do not exist"} = Jason.decode!(conn.resp_body)
    end

    # show customer
    test "GET customers show" do
      create_admin()
      {:ok, _, token} = auth_admin()

      {:ok, customer} = create_customer()

      conn =
        :get
        |> conn("/api/customers/#{customer.id}")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "Customer viewed with success!"} = Jason.decode!(conn.resp_body)
    end

    # update customer
    test "PUT customers update" do
      create_admin()
      {:ok, _, token} = auth_admin()

      {:ok, customer} = create_customer()

      conn =
        :put
        |> conn("/api/customers/#{customer.id}", %{
          "customer" => @update_attrs
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "Customer updated with success!"} = Jason.decode!(conn.resp_body)
    end

    # update customer failed
    test "PUT customers update failed" do
      create_admin()
      {:ok, _, token} = auth_admin()

      conn =
        :put
        |> conn("/api/customers/100", %{
          "customer" => @update_attrs
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "This customer do not exist"} = Jason.decode!(conn.resp_body)
    end

    # update customer unauthorized
    test "PUT customers update unauthorized" do
      {:ok, _, token} = create_customer_and_token()

      conn =
        :put
        |> conn("/api/customers/100", %{
          "customer" => @update_attrs
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # delete customer
    test "DELETE customers delete" do
      create_admin()
      {:ok, _, token} = auth_admin()

      {:ok, customer} = create_customer()

      conn =
        :delete
        |> conn("/api/customers/#{customer.id}")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "Customer deleted with success!"} = Jason.decode!(conn.resp_body)
    end

    # delete customer failed
    test "DELETE customers delete failed" do
      create_admin()
      {:ok, _, token} = auth_admin()

      conn =
        :delete
        |> conn("/api/customers/100")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "This customer do not exist"} = Jason.decode!(conn.resp_body)
    end

    # delete customer unauthorized
    test "DELETE customers delete unauthorized" do
      {:ok, _, token} = create_customer_and_token()

      conn =
        :delete
        |> conn("/api/customers/100")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end
  end
end
