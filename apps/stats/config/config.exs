use Mix.Config

config :stats, ecto_repos: [Stats.Repo]

import_config "#{Mix.env}.exs"
