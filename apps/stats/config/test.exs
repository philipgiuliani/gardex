use Mix.Config

config :stats, Stats.Repo,
  adapter: Sqlite.Ecto,
  database: "stats.sqlite"
