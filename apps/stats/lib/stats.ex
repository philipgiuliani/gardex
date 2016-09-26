defmodule Stats do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Stats.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Stats.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
