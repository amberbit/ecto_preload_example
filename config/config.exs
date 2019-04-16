use Mix.Config

config :ecto_preload_example, EctoPreloadExample.Repo,
  database: "ecto_preload_example",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :ecto_preload_example, ecto_repos: [EctoPreloadExample.Repo]
