defmodule Stats do
  use Application

  alias Stats.Stat
  alias Stats.Repo
  import Ecto.Query, only: [where: 2, where: 3]

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
  def get_stats(sensor_id) do
    %{year: year, month: month, day: day} = DateTime.utc_now
    {:ok, date} = Date.new(year, month, day)
    get_stats(sensor_id, date)
  end
  def get_stats(sensor_id, date) do
    date_erl = Date.to_erl(date)
    from_time = Ecto.DateTime.from_erl({date_erl,{0, 0, 0}})
    to_time = Ecto.DateTime.from_erl({date_erl,{23, 59, 59}})

    Stat
    |> where(sensor_id: ^sensor_id)
    |> where([s], s.inserted_at >= ^from_time)
    |> where([s], s.inserted_at <= ^to_time)
    |> Repo.all()
  end

  defp storage_up() do
    Stats.Repo.config()
    |> Sqlite.Ecto.storage_up()
  end

  defp migrate() do
    path = Application.app_dir(:stats, "priv/repo/migrations")
    Ecto.Migrator.run(Stats.Repo, path, :up, all: true)
  end
end
