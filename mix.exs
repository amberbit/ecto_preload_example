defmodule EctoPreloadExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_preload_example,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EctoPreloadExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "3.1.1"},
      {:ecto_sql, "3.1.0"},
      {:postgrex, "0.14.2"}
    ]
  end
end
