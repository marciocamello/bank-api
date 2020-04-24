defmodule BankApi.Api.UserTest do
  use BankApi.AppCase, assync: true
  use Plug.Test
  doctest BankApi

  alias BankApi.Router

  # global fixtures
  use BankApi.Fixtures, [:customer, :transaction]

  @opts Router.init([])

  # Descript api tests
  describe "user" do
    # page not found
    test "returns Page not found" do
      conn =
        :get
        |> conn("/api/user/missing")
        |> Router.call(@opts)

      assert conn.status == 404
      assert %{"message" => "Page not found"} = Jason.decode!(conn.resp_body)
    end

    # register user
    test "POST user/register and verify attributes" do
      conn =
        :post
        |> conn("/api/user/register", %{"customer" => @create_attrs})
        |> Router.call(@opts)

      assert conn.status == 200

      %{
        "customer" => %{
          "email" => email,
          "firstName" => firstName,
          "lastName" => lastName,
          "phone" => phone,
          "acl" => acl
        }
      } = Jason.decode!(conn.resp_body)

      assert email == @create_attrs.email
      assert firstName == @create_attrs.firstName
      assert lastName == @create_attrs.lastName
      assert phone == @create_attrs.phone
      assert acl == @create_attrs.acl
    end

    # register user failed
    test "POST user/register failed" do
      conn =
        :post
        |> conn("/api/user/register", %{"customer" => %{}})
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => %{}} = Jason.decode!(conn.resp_body)
    end

    # login user
    test "POST auth/login and get token" do
      create_customer()

      conn =
        :post
        |> conn("/api/auth/login", %{
          email: @create_attrs.email,
          password: @create_attrs.password
        })
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"customer" => %{}, "token" => token} = Jason.decode!(conn.resp_body)
    end

    # login user unauthorized
    test "POST auth/login unauthorized" do
      create_customer()

      conn =
        :post
        |> conn("/api/auth/login", %{
          email: @create_attrs.email,
          password: "wrongpassword"
        })
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # login user invalid credentials
    test "POST auth/login invalid credentials" do
      create_customer()

      conn =
        :post
        |> conn("/api/auth/login", %{
          email: "",
          password: ""
        })
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Invalid credentials"} = Jason.decode!(conn.resp_body)
    end

    # show current user
    test "GET user/account" do
      {:ok, %Customer{}, token} = create_customer_and_token()

      conn =
        :get
        |> conn("/api/user/account")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
    end

    # show current user
    test "GET user/account unauthorized" do
      conn =
        :get
        |> conn("/api/user/account")
        |> put_req_header("authorization", "Bearer wrongtoken")
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # withdrawal password don't confirmed
    test "POST user/withdrawal to get money from current account and password don't confirm" do
      {:ok, %Customer{}, token} = create_customer_and_token()

      conn =
        :post
        |> conn("/api/user/withdrawal", @withdrawal_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      %{"message" => message} = Jason.decode!(conn.resp_body)
      assert "Please check your transation" == message
    end

    # withdrawal password confirmed
    test "POST user/withdrawal to get money from current account and password confirmed" do
      {:ok, %Customer{}, token} = create_customer_and_token()

      conn =
        :post
        |> conn("/api/user/withdrawal", @withdrawal_confirm_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"result" => %{"new_balance" => new_balance}} = Jason.decode!(conn.resp_body)
      assert Decimal.eq?(new_balance, Decimal.from_float(990.00)) == true
    end

    # withdrawal check have funds in account
    test "POST user/withdrawal check have funds in account" do
      {:ok, %Customer{}, token} = create_customer_and_token()

      params =
        @withdrawal_confirm_attrs
        |> Map.put("value", 2000.00)

      conn =
        :post
        |> conn("/api/user/withdrawal", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "You don't have enough funds"} = Jason.decode!(conn.resp_body)
    end

    # withdrawal check zero value
    test "POST user/withdrawal check zero value" do
      {:ok, %Customer{}, token} = create_customer_and_token()

      params =
        @withdrawal_confirm_attrs
        |> Map.put("value", 0.00)

      conn =
        :post
        |> conn("/api/user/withdrawal", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Value cannot be less than 0.00"} = Jason.decode!(conn.resp_body)
    end

    # withdrawal unauthorized
    test "POST user/withdrawal unauthorized" do
      {:ok, %Customer{}, token} = create_customer_and_token()

      params =
        @withdrawal_confirm_attrs
        |> Map.put("password_confirm", "wrongpassword")

      conn =
        :post
        |> conn("/api/user/withdrawal", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Invalid credentials"} = Jason.decode!(conn.resp_body)
    end

    # withdrawal token Unauthorized
    test "POST user/withdrawal token Unauthorized" do
      params =
        @transfer_confirm_attrs
        |> Map.put("account_to", "wrongemail@email.com")

      conn =
        :post
        |> conn("/api/user/withdrawal", params)
        |> put_req_header("authorization", "Bearer wrongtoken")
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # transfer money to other account and password don't confirm
    test "POST user/transfer money to other account and password don't confirm" do
      {:ok, %Customer{}, token} = create_customer_and_authenticate_transfer_token()

      conn =
        :post
        |> conn("/api/user/transfer", @transfer_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      %{"message" => message} = Jason.decode!(conn.resp_body)
      assert "Please check your transation" == message
    end

    # transfer to get money from current account and password confirmed
    test "POST user/transfer to get money from current account and password confirmed" do
      {:ok, %Customer{}, token} = create_customer_and_authenticate_transfer_token()

      conn =
        :post
        |> conn("/api/user/transfer", @transfer_confirm_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"result" => %{"new_balance" => new_balance}} = Jason.decode!(conn.resp_body)
      assert Decimal.eq?(new_balance, Decimal.from_float(1010.00)) == true
    end

    # transfer check have funds in account
    test "POST user/transfer check have funds in account" do
      {:ok, %Customer{}, token} = create_customer_and_authenticate_transfer_token()

      params =
        @transfer_confirm_attrs
        |> Map.put("value", 2000.00)

      conn =
        :post
        |> conn("/api/user/transfer", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "You don't have enough funds"} = Jason.decode!(conn.resp_body)
    end

    # transfer check zero value
    test "POST user/transfer check zero value" do
      {:ok, %Customer{}, token} = create_customer_and_authenticate_transfer_token()

      params =
        @transfer_confirm_attrs
        |> Map.put("value", 0.00)

      conn =
        :post
        |> conn("/api/user/transfer", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Value cannot be less than 0.00"} = Jason.decode!(conn.resp_body)
    end

    # transfer unauthorized
    test "POST user/transfer unauthorized" do
      {:ok, %Customer{}, token} = create_customer_and_authenticate_transfer_token()

      params =
        @transfer_confirm_attrs
        |> Map.put("password_confirm", "wrongpassword")

      Unauthorized

      conn =
        :post
        |> conn("/api/user/transfer", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Invalid credentials"} = Jason.decode!(conn.resp_body)
    end

    # transfer not_found
    test "POST user/transfer not_found" do
      {:ok, %Customer{}, token} = create_customer_and_authenticate_transfer_token()

      params =
        @transfer_confirm_attrs
        |> Map.put("account_to", "wrongemail@email.com")

      conn =
        :post
        |> conn("/api/user/transfer", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Invalid account data"} = Jason.decode!(conn.resp_body)
    end

    # transfer token Unauthorized
    test "POST user/transfer token Unauthorized" do
      params =
        @transfer_confirm_attrs
        |> Map.put("account_to", "wrongemail@email.com")

      conn =
        :post
        |> conn("/api/user/transfer", params)
        |> put_req_header("authorization", "Bearer wrongtoken")
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # terminate account
    test "GET user/terminate" do
      {:ok, %Customer{}, token} = create_customer_and_token()

      conn =
        :get
        |> conn("/api/user/terminate")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "Your account has been terminated"} = Jason.decode!(conn.resp_body)
    end

    # terminate account failed
    test "GET user/terminate failed" do
      conn =
        :get
        |> conn("/api/user/terminate")
        |> put_req_header("authorization", "Bearer wrongtoken")
        |> Router.call(@opts)

      assert conn.status == 200

      assert %{"errors" => "You need authenticated to this action"} =
               Jason.decode!(conn.resp_body)
    end
  end
end
