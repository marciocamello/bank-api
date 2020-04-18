defmodule BankApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank_api,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "BankApi",
      source_url: "https://github.com/USER/PROJECT",
      homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      docs: [
        # The main page in the docs
        main: "BankApi",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
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
end
