defmodule BankApi.Api.AccountTest do
  use BankApi.AppCase, assync: true
  use Plug.Test
  doctest BankApi

  alias BankApi.Router

  # global fixtures
  use BankApi.Fixtures, [:user, :transaction]

  @opts Router.init([])

  # Descript api tests
  describe "account" do
    # page not found
    test "returns Page not found" do
      conn =
        :get
        |> conn("/api/account/missing")
        |> Router.call(@opts)

      assert conn.status == 404
      assert %{"message" => "Page not found"} = Jason.decode!(conn.resp_body)
    end

    # create user
    test "POST account/create and verify attributes" do
      conn =
        :post
        |> conn("/api/account/create", %{"user" => @create_attrs})
        |> Router.call(@opts)

      assert conn.status == 200

      %{
        "user" => %{
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

    # create user failed
    test "POST account/create failed" do
      conn =
        :post
        |> conn("/api/account/create", %{"user" => %{}})
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => %{}} = Jason.decode!(conn.resp_body)
    end

    # login user
    test "POST auth/login and get token" do
      create_user()

      conn =
        :post
        |> conn("/api/auth/login", %{
          email: @create_attrs.email,
          password: @create_attrs.password
        })
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"user" => %{}, "token" => token} = Jason.decode!(conn.resp_body)
    end

    # login user unauthorized
    test "POST auth/login unauthorized" do
      create_user()

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
      create_user()

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

    # show current account
    test "GET account/index" do
      {:ok, %User{}, token} = create_user_and_token()

      conn =
        :get
        |> conn("/api/account/index")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
    end

    # show current account
    test "GET account/index unauthorized" do
      conn =
        :get
        |> conn("/api/account/index")
        |> put_req_header("authorization", "Bearer wrongtoken")
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # withdrawal password don't confirmed
    test "POST account/withdrawal to get money from current account and password don't confirm" do
      {:ok, %User{}, token} = create_user_and_token()

      conn =
        :post
        |> conn("/api/account/withdrawal", @withdrawal_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      %{"message" => message} = Jason.decode!(conn.resp_body)
      assert "Please check your transation" == message
    end

    # withdrawal password confirmed
    test "POST account/withdrawal to get money from current account and password confirmed" do
      {:ok, %User{}, token} = create_user_and_token()

      conn =
        :post
        |> conn("/api/account/withdrawal", @withdrawal_confirm_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"result" => %{"new_balance" => new_balance}} = Jason.decode!(conn.resp_body)
      assert Decimal.eq?(new_balance, Decimal.from_float(990.00)) == true
    end

    # withdrawal check have funds in account
    test "POST account/withdrawal check have funds in account" do
      {:ok, %User{}, token} = create_user_and_token()

      params =
        @withdrawal_confirm_attrs
        |> Map.put("value", 2000.00)

      conn =
        :post
        |> conn("/api/account/withdrawal", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "You don't have enough funds"} = Jason.decode!(conn.resp_body)
    end

    # withdrawal check zero value
    test "POST account/withdrawal check zero value" do
      {:ok, %User{}, token} = create_user_and_token()

      params =
        @withdrawal_confirm_attrs
        |> Map.put("value", 0.00)

      conn =
        :post
        |> conn("/api/account/withdrawal", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Value cannot be less than 0.00"} = Jason.decode!(conn.resp_body)
    end

    # withdrawal unauthorized
    test "POST account/withdrawal unauthorized" do
      {:ok, %User{}, token} = create_user_and_token()

      params =
        @withdrawal_confirm_attrs
        |> Map.put("password_confirm", "wrongpassword")

      conn =
        :post
        |> conn("/api/account/withdrawal", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Invalid credentials"} = Jason.decode!(conn.resp_body)
    end

    # withdrawal token Unauthorized
    test "POST account/withdrawal token Unauthorized" do
      params =
        @transfer_confirm_attrs
        |> Map.put("account_to", "wrongemail@email.com")

      conn =
        :post
        |> conn("/api/account/withdrawal", params)
        |> put_req_header("authorization", "Bearer wrongtoken")
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # transfer money to other account and password don't confirm
    test "POST account/transfer money to other account and password don't confirm" do
      {:ok, %User{}, token} = create_user_and_authenticate_transfer_token()

      conn =
        :post
        |> conn("/api/account/transfer", @transfer_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      %{"message" => message} = Jason.decode!(conn.resp_body)
      assert "Please check your transation" == message
    end

    # transfer to get money from current account and password confirmed
    test "POST account/transfer to get money from current account and password confirmed" do
      {:ok, %User{}, token} = create_user_and_authenticate_transfer_token()

      conn =
        :post
        |> conn("/api/account/transfer", @transfer_confirm_attrs)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"result" => %{"new_balance" => new_balance}} = Jason.decode!(conn.resp_body)
      assert Decimal.eq?(new_balance, Decimal.from_float(1010.00)) == true
    end

    # transfer check have funds in account
    test "POST account/transfer check have funds in account" do
      {:ok, %User{}, token} = create_user_and_authenticate_transfer_token()

      params =
        @transfer_confirm_attrs
        |> Map.put("value", 2000.00)

      conn =
        :post
        |> conn("/api/account/transfer", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "You don't have enough funds"} = Jason.decode!(conn.resp_body)
    end

    # transfer check zero value
    test "POST account/transfer check zero value" do
      {:ok, %User{}, token} = create_user_and_authenticate_transfer_token()

      params =
        @transfer_confirm_attrs
        |> Map.put("value", 0.00)

      conn =
        :post
        |> conn("/api/account/transfer", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Value cannot be less than 0.00"} = Jason.decode!(conn.resp_body)
    end

    # transfer unauthorized
    test "POST account/transfer unauthorized" do
      {:ok, %User{}, token} = create_user_and_authenticate_transfer_token()

      params =
        @transfer_confirm_attrs
        |> Map.put("password_confirm", "wrongpassword")

      Unauthorized

      conn =
        :post
        |> conn("/api/account/transfer", params)
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Invalid credentials"} = Jason.decode!(conn.resp_body)
    end

    # transfer not_found
    test "POST account/transfer not_found" do
      {:ok, %User{}, token} = create_user_and_authenticate_transfer_token()

      params =
        @transfer_confirm_attrs
        |> Map.put("account_to", "wrongemail@email.com")

      conn =
        :post
        |> conn("/api/account/transfer", params)
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
        |> conn("/api/account/transfer", params)
        |> put_req_header("authorization", "Bearer wrongtoken")
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # terminate account
    test "GET account/terminate" do
      {:ok, %User{}, token} = create_user_and_token()

      conn =
        :get
        |> conn("/api/account/terminate")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "Your account has been terminated"} = Jason.decode!(conn.resp_body)
    end

    # terminate account failed
    test "GET account/terminate failed" do
      conn =
        :get
        |> conn("/api/account/terminate")
        |> put_req_header("authorization", "Bearer wrongtoken")
        |> Router.call(@opts)

      assert conn.status == 200

      assert %{"errors" => "You need authenticated to this action"} =
               Jason.decode!(conn.resp_body)
    end
  end
end
