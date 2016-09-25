defmodule Stats do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Sqlitex.Server, ["stats.sqlite3", [name: Sqlitex.Server]]
    ]

    opts = [strategy: :one_for_one, name: Stats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def get_stats(pot_id) do
    Sqlitex.Server.query(Sqlitex.Server,
                         "SELECT *
                          FROM stats
                          WHERE pot_id = '#{pot_id}'")
  end
end
