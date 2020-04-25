defmodule BankApi.Controllers.User do
  @moduledoc """
    User Controller context
  """
  use Plug.Router
  alias BankApi.Repo
  alias BankApi.Auth.Guardian
  alias BankApi.Helpers.TranslateError
  alias BankApi.Models.Users
  alias BankApi.Router

  plug(:match)
  plug(BankApi.Auth.Pipeline)
  plug(:dispatch)

  @doc """
    Show account logged
  """
  get "/" do
    token = Router.get_bearer_token(conn)

    if Guardian.is_admin(token) do
      users =
        Users.list_users()
        |> Repo.preload(:accounts)

      Router.render_json(conn, %{message: "User listed with success!", users: users})
    else
      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Create account route
  """
  post "/" do
    token = Router.get_bearer_token(conn)

    if Guardian.is_admin(token) do
      %{"user" => user} = conn.body_params

      case Users.create_user(user) do
        {:ok, _user} ->
          Users.bind_account(_user)
          user = Users.get_user(_user.id)

          Router.render_json(conn, %{
            message: "User created with success!",
            user: user
          })

        {:error, _changeset} ->
          Router.render_json(conn, %{errors: TranslateError.pretty_errors(_changeset)})
      end
    else
      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Show user logged by id
  """
  get "/:id" do
    token = Router.get_bearer_token(conn)

    if Guardian.is_admin(token) do
      %{"id" => id} = conn.path_params

      case Users.get_user(id) do
        nil ->
          Router.render_json(conn, %{errors: "This user do not exist"})

        user ->
          Router.render_json(conn, %{message: "User viewed with success!", user: user})
      end
    else
      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Update user logged by id
  """
  put "/:id" do
    token = Router.get_bearer_token(conn)

    if Guardian.is_admin(token) do
      %{"id" => id} = conn.path_params
      %{"user" => params} = conn.body_params

      case Users.get_user(id) do
        nil ->
          Router.render_json(conn, %{errors: "This user do not exist"})

        user ->
          Users.update_user(user, params)

          Router.render_json(conn, %{
            message: "User updated with success!",
            user: user
          })
      end
    else
      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end

  @doc """
    Delete user logged by id
  """
  delete "/:id" do
    token = Router.get_bearer_token(conn)

    if Guardian.is_admin(token) do
      %{"id" => id} = conn.path_params

      case Users.get_user(id) do
        nil ->
          Router.render_json(conn, %{errors: "This user do not exist"})

        user ->
          Users.delete_user(user)
          Router.render_json(conn, %{message: "User deleted with success!"})
      end
    else
      Router.render_json(conn, %{errors: "Unauthorized"})
    end
  end
end
