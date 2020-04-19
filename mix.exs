defmodule BankApi.MixProject do
  use Mix.Project

  def project do
    [
      # Application
      app: :bank_api,
      version: "0.1.0",
      elixir: "~> 1.10",
      description:
        "Financial application, create customers and accounts, and operations financials.",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),

      # Docs
      name: "BankApi",
      source_url: "https://gitlab.com/marcio-elixir/bank-api",
      homepage_url: "https://gitlab.com/marcio-elixir/bank-api",
      docs: [
        # The main page in the docs
        main: "readme",
        logo: "logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :runtime_tools],
      mod: {BankApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:ecto_sql, "~> 3.2"},
      {:postgrex, "~> 0.15"},
      {:plug_cowboy, "~> 2.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:bcrypt_elixir, "~> 2.0"},
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
      {:guardian, "~> 2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
