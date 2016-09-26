defmodule Stats do
  use Application

  alias Stats.Stat
  alias Stats.Repo
  import Ecto.Query, only: [where: 2]

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # worker(Stats.Repo, []),
      # worker(Stats.Monitor, [])
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])

    {:ok, self}
  end

  def get_stats(sensor_id) when is_atom(sensor_id), do: Atom.to_string(sensor_id)
  def get_stats(sensor_id) do
    Stat
    |> where(sensor_id: ^sensor_id)
    |> Repo.all()
  end

  def storage_up() do
    Sqlite.Ecto.storage_up([database: "/root/stats.sqlite"])
  end

  def migrate() do
    path = Application.app_dir(:stats, "priv/repo/migrations")
    Ecto.Migrator.run(Stats.Repo, path, :up, all: true)
  end
end
