defmodule BankApi.Release do
  @app :bank_api

  alias BankApi.Seed.{Admin, Users}

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def down do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed do
    for repo <- repos() do

      [:postgrex, :ecto]
      |> Enum.each(&Application.ensure_all_started/1)
      repo.start_link

      repo.truncate(BankApi.Schemas.User)
      Admin.add_admin()
      Users.add_user()
    end
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end