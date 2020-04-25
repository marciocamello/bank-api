defmodule Mix.Tasks.Utils.Seed do
  use Mix.Task

  alias BankApi.Repo
  alias BankApi.Seed.{Admin, Users}

  @shortdoc "Run BankApi Seeds"
  def run(_) do

    Mix.env(:dev)

    [:postgrex, :ecto]
    |> Enum.each(&Application.ensure_all_started/1)
    Repo.start_link

    Repo.truncate(BankApi.Schemas.User)
    Admin.add_admin()
    Users.add_user()

    IO.puts("Seed run with success!")
  end
end