defmodule Stats.Mixfile do
  use Mix.Project

  def project do
    [app: :stats,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :sqlite_ecto, :ecto, :sqlitex, :db_connection],
     mod: {Stats, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:core, in_umbrella: true},
     {:ecto, "~> 2.0.0"},
     {:poison, "~> 2.0.0", override: true},
     {:sqlite_ecto, github: "philipgiuliani/sqlite_ecto", branch: "feature/ecto-2.0"}]
  end
end
