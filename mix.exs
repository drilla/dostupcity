defmodule Dostup.MixProject do
  use Mix.Project

  def project do
    [
      app: :dostup,
      version: "0.1.0",
      elixir: "~> 1.10.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Dostup.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.5.1"},
      {:phoenix_ecto, "~> 4.1"},
      {:scrivener_ecto, "~> 2.0"},
      {:plug_cowboy, "~> 2.0"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:csv, "~> 2.3"},
      {:bamboo, "~> 1.5"},
      {:bamboo_smtp, "~> 2.1.0"},
      {:phoenix_html_sanitizer, "~> 1.0.0"},
      {:email_checker, "~> 0.1.2"},
      {:pdf_generator, ">=0.6.0"},
      {:joken, "~> 2.2"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create", "ecto.migrate", "test"]
    ]
  end
end
