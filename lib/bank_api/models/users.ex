defmodule BankApi.Models.Users do
  @moduledoc """
    Users model
  """
  import Ecto
  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Schemas.User
  alias BankApi.Router

  @doc """
    List all users

  # Examples
      iex> alias BankApi.Models.Users
      iex> Users.list_users
      [ %BankApi.Schemas.User{} ]
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
    Create user

  # Examples
      iex> alias BankApi.Models.Users
      iex> Users.create_user(
        %{
          "email" => "email@email.com",
          "firstName" => "firstName",
          "lastName" => "lastName",
          "phone" => "00 0000 0000",
          "password" => "123456"
        }
      )
      { :ok, %BankApi.Schemas.User{} }
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Bind account to user

  # Examples
      iex> alias BankApi.Models.Users
      iex> user = Users.get_user(id)
      iex> account = Users.bind_account(user)
      %BankApi.Schemas.Account{}
  """
  def bind_account(user) do
    Ecto.build_assoc(user, :accounts)
    |> Repo.insert!()
  end

  @doc """
    Get user from id

  # Examples
      iex> alias BankApi.Models.Users
      iex> Users.create_user(
        %{
          "email" => "email@email.com",
          "firstName" => "firstName",
          "lastName" => "lastName",
          "phone" => "00 0000 0000",
          "password" => "123456"
        }
      )
      { :ok, %BankApi.Schemas.User{} }
  """
  def get_user(id) do
    Repo.get(User, id)
    |> Repo.preload(accounts: [:user])
  end

  @doc """
    Update user from user instance

  # Examples
      iex> alias BankApi.Models.Users
      iex> user = Users.get_user(id)
      iex> Users.update_user(
        user,
        %{
          "email" => "new_email@email.com",
          "firstName" => "New_firstName",
          "lastName" => "New_lastName",
          "phone" => "11 1111 1111",
          "password" => "654321"
        }
      )
      { :ok, %BankApi.Schemas.User{} }
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
    Get user from email

  # Examples
      iex> alias BankApi.Models.Users
      iex> Users.get_by_email(
        "email@email.com"
      )
      { :ok, %BankApi.Schemas.User{} }
  """
  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}

      user ->
        user =
          user
          |> Repo.preload(accounts: [:user])

        {:ok, user}
    end
  end

  @doc """
    Delete user from user instance

  # Examples
      iex> alias BankApi.Models.Users
      iex> user = Users.get_user(id)
      iex> Users.delete_user(user)
      { :ok, %BankApi.Schemas.User{} }
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
