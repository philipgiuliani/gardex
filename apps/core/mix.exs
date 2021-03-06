defmodule Core.Mixfile do
  use Mix.Project

  def project do
    [app: :core,
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
    [mod: {Core, []},
     applications: applications(Mix.env)]
  end

  defp applications(:prod), do: [:elixir_ale | general_apps]
  defp applications(_), do: general_apps

  defp general_apps, do: [:logger]

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
    [{:elixir_ale, "~> 0.5.5", only: :prod},
     {:dummy_nerves, in_umbrella: true, only: [:dev, :test]}]
  end
end
