defmodule BankApi.Api.UserTest do
  use BankApi.AppCase, assync: true
  use Plug.Test
  doctest BankApi

  alias BankApi.Router

  # global fixtures
  use BankApi.Fixtures, [:user, :transaction]

  @opts Router.init([])

  # Descript api tests
  describe "users" do
    # unauthorized user
    test "GET users unauthorized user" do
      conn =
        :get
        |> conn("/api/users")
        |> Router.call(@opts)

      assert conn.status == 401
    end

    # users failed
    test "GET users failed" do
      {:ok, %User{}, token} = create_user_and_token()

      conn =
        :get
        |> conn("/api/users")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # list all users
    test "GET users list" do
      create_admin()
      {:ok, %User{}, token} = auth_admin()

      conn =
        :get
        |> conn("/api/users")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "User listed with success!"} = Jason.decode!(conn.resp_body)
    end

    # create user failed
    test "POST users create failed" do
      create_admin()
      {:ok, %User{}, token} = auth_admin()

      conn =
        :post
        |> conn("/api/users", %{
          "user" => %{}
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => _changeset} = Jason.decode!(conn.resp_body)
    end

    # create user unauthorized
    test "POST users create unauthorized" do
      {:ok, %User{}, token} = create_user_and_token()

      conn =
        :post
        |> conn("/api/users", %{
          "user" => %{}
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # create user
    test "POST users create" do
      create_admin()
      {:ok, %User{}, token} = auth_admin()

      conn =
        :post
        |> conn("/api/users", %{
          "user" => @create_attrs
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "User created with success!"} = Jason.decode!(conn.resp_body)
    end

    # show user unauthorized
    test "GET users show unauthorized" do
      {:ok, user, token} = create_user_and_token()

      conn =
        :get
        |> conn("/api/users/#{user.id}")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # show user not found
    test "GET users show not found" do
      create_admin()
      {:ok, %User{}, token} = auth_admin()

      conn =
        :get
        |> conn("/api/users/100")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "This user do not exist"} = Jason.decode!(conn.resp_body)
    end

    # show user
    test "GET users show" do
      create_admin()
      {:ok, _, token} = auth_admin()

      {:ok, user} = create_user()

      conn =
        :get
        |> conn("/api/users/#{user.id}")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "User viewed with success!"} = Jason.decode!(conn.resp_body)
    end

    # update user
    test "PUT users update" do
      create_admin()
      {:ok, _, token} = auth_admin()

      {:ok, user} = create_user()

      conn =
        :put
        |> conn("/api/users/#{user.id}", %{
          "user" => @update_attrs
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "User updated with success!"} = Jason.decode!(conn.resp_body)
    end

    # update user failed
    test "PUT users update failed" do
      create_admin()
      {:ok, _, token} = auth_admin()

      conn =
        :put
        |> conn("/api/users/100", %{
          "user" => @update_attrs
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "This user do not exist"} = Jason.decode!(conn.resp_body)
    end

    # update user unauthorized
    test "PUT users update unauthorized" do
      {:ok, _, token} = create_user_and_token()

      conn =
        :put
        |> conn("/api/users/100", %{
          "user" => @update_attrs
        })
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end

    # delete user
    test "DELETE users delete" do
      create_admin()
      {:ok, _, token} = auth_admin()

      {:ok, user} = create_user()

      conn =
        :delete
        |> conn("/api/users/#{user.id}")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"message" => "User deleted with success!"} = Jason.decode!(conn.resp_body)
    end

    # delete user failed
    test "DELETE users delete failed" do
      create_admin()
      {:ok, _, token} = auth_admin()

      conn =
        :delete
        |> conn("/api/users/100")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "This user do not exist"} = Jason.decode!(conn.resp_body)
    end

    # delete user unauthorized
    test "DELETE users delete unauthorized" do
      {:ok, _, token} = create_user_and_token()

      conn =
        :delete
        |> conn("/api/users/100")
        |> put_req_header("authorization", "Bearer " <> token)
        |> Router.call(@opts)

      assert conn.status == 200
      assert %{"errors" => "Unauthorized"} = Jason.decode!(conn.resp_body)
    end
  end
end
