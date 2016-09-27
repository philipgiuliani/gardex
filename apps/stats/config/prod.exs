use Mix.Config

config :stats, Stats.Repo,
  adapter: Sqlite.Ecto,
  database: "/root/stats.sqlite"
