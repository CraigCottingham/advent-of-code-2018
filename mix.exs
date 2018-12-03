defmodule AoC.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "2018.0.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [espec: :test],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.10.2", only: [:dev, :test], runtime: false},
      {:espec, "~> 1.6", only: :test},
      {:ex_machina, "~> 2.2"},
      {:faker, "~> 0.11.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 0.9.0", only: :dev, runtime: false},
      {:yamerl, "~> 0.7.0", only: :test}
    ]
  end
end
