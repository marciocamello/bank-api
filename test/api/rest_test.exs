defmodule BankApi.Api.RestTest do
  use BankApi.AppCase, assync: true
  use Plug.Test
  doctest BankApi

  alias BankApi.Router

  # sandbox sql setup
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BankApi.Repo)
  end

  # global fixtures
  use BankApi.Fixtures, [:customer, :transaction]

  @opts Router.init([])

  # Descript api tests
  describe "api" do
    # register user
    test "POST user/register and verify attributes" do
      conn =
        :post
        |> conn("/api/user/register", %{"customer" => @create_attrs})
        |> Router.call(@opts)

      assert conn.status == 200

      %{
        "customer" => %{
          "id" => id,
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

    # show current user
    test "GET user/account" do
      {:ok, %Customer{}, _token} = create_customer_and_token

      conn =
        :get
        |> conn("/api/user/account")
        |> put_req_header("authorization", "Bearer " <> _token)
        |> Router.call(@opts)

      assert conn.status == 200
    end

    # withdrawal password don't confirmed
    test "POST user/withdrawal to get money from current account and password don't confirm" do
      {:ok, %Customer{}, _token} = create_customer_and_token

      conn =
        :post
        |> conn("/api/user/withdrawal", @withdrawal_attrs)
        |> put_req_header("authorization", "Bearer " <> _token)
        |> Router.call(@opts)

      assert conn.status == 200
      %{"message" => message} = Jason.decode!(conn.resp_body)
      assert "Please check your transation" == message
    end

    # withdrawal password confirmed
    test "POST user/withdrawal to get money from current account and password confirmed" do
      {:ok, %Customer{}, _token} = create_customer_and_token

      conn =
        :post
        |> conn("/api/user/withdrawal", @withdrawal_confirm_attrs)
        |> put_req_header("authorization", "Bearer " <> _token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"result" => %{"new_balance" => new_balance}} = Jason.decode!(conn.resp_body)
      assert Decimal.eq?(new_balance, Decimal.from_float(990.00)) == true
    end

    # transfer money to other account and password don't confirm
    test "POST user/transfer money to other account and password don't confirm" do
      {:ok, %Customer{}, _token} = create_customer_and_authenticate_transfer_token

      conn =
        :post
        |> conn("/api/user/transfer", @transfer_attrs)
        |> put_req_header("authorization", "Bearer " <> _token)
        |> Router.call(@opts)

      assert conn.status == 200
      %{"message" => message} = Jason.decode!(conn.resp_body)
      assert "Please check your transation" == message
    end

    # transfer to get money from current account and password confirmed
    test "POST user/transfer to get money from current account and password confirmed" do
      {:ok, %Customer{}, _token} = create_customer_and_authenticate_transfer_token

      conn =
        :post
        |> conn("/api/user/transfer", @transfer_confirm_attrs)
        |> put_req_header("authorization", "Bearer " <> _token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"result" => %{"new_balance" => new_balance}} = Jason.decode!(conn.resp_body)
      assert Decimal.eq?(new_balance, Decimal.from_float(1010.00)) == true
    end

    # terminate account
  end
end
