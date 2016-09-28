defmodule Fw.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi"

  def project do
    [app: :fw,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.1.4"],
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(Mix.env),
     deps: deps ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Fw, []},
     applications: applications(Mix.env)]
  end

  defp applications(:prod), do: [:nerves_ntp] ++ applications
  defp applications(_), do: applications
  defp applications(), do: [:logger, :core, :api, :nerves_networking, :stats]

  def deps do
    [{:nerves, "~> 0.3.0"},
     {:nerves_networking, github: "nerves-project/nerves_networking"},
     {:sqlite_ecto, github: "philipgiuliani/sqlite_ecto", branch: "feature/ecto-2.0"},
     {:nerves_ntp, "~> 0.1.0", only: :prod},
     {:core, in_umbrella: true},
     {:stats, in_umbrella: true},
     {:api, in_umbrella: true}]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases(:prod) do
    ["deploy": ["firmware", "firmware.burn"],
     "upgrade": ["firmware", "firmware.burn --task upgrade"]] ++ aliases
  end
  def aliases(_), do: aliases
  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
end
