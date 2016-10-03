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
     applications: [:logger, :nerves_networking, :core, :api, :stats, :slackbot]]
  end

  def deps do
    [{:nerves, "~> 0.3.0"},
     {:nerves_networking, github: "nerves-project/nerves_networking"},
     {:core, in_umbrella: true},
     {:stats, in_umbrella: true},
     {:api, in_umbrella: true},
     {:slackbot, in_umbrella: true}]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases(:prod) do
    ["deploy": ["firmware", "firmware.burn"],
     "upgrade": ["firmware", "firmware.burn -t upgrade"]] ++ aliases
  end
  def aliases(_), do: aliases
  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
end
