defmodule Stats do
  use Application

  @db_config Application.get_env(:stats, Stats.Repo)

  alias Stats.Stat
  alias Stats.Repo
  import Ecto.Query, only: [where: 2]

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Create database
    storage_up()

    # Start childs
    children = [
      worker(Stats.Repo, []),
      worker(Stats.Monitor, [])
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])

    # Migrate database after Stats.Repo has been started
    migrate()

    {:ok, self}
  end

  @doc """
  Returns the stats of a given sensor
  """
  def get_stats(sensor_id) when is_atom(sensor_id), do: Atom.to_string(sensor_id)
  def get_stats(sensor_id) do
    Stat
    |> where(sensor_id: ^sensor_id)
    |> Repo.all()
  end

  @doc """
  Creates the sqlite database
  """
  defp storage_up() do
    Sqlite.Ecto.storage_up(@db_config)
  end

  @doc """
  Runs all migrations
  """
  defp migrate() do
    path = Application.app_dir(:stats, "priv/repo/migrations")
    Ecto.Migrator.run(Stats.Repo, path, :up, all: true)
  end
end
