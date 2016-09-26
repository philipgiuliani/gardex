use Mix.Config

config :stats, ecto_repos: [Stats.Repo]

config :stats, Stats.Repo,
  adapter: Sqlite.Ecto,
  database: "stats.sqlite3"
