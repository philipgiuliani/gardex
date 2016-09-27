defmodule Api.Router do
  use Plug.Router

  alias Core.Pot
  alias Core.Sensor

  plug :match
  plug :dispatch

  get "/pots" do
    pots =
      Core.get_pots()
      |> Enum.map(&build_pot_resp(&1))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{pots: pots}))
  end

  get "/sensors/:sensor" do
    stats =
      Stats.get_stats(sensor)
      |> Enum.map(&build_stat_resp(&1))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{stats: stats}))
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp build_pot_resp(pid) do
    name = Pot.name(pid)
    sensors = Pot.sensors(pid)

    %{name: name,
      sensors: Enum.map(sensors, &build_sensor_resp(&1))}
  end

  defp build_sensor_resp(pid) do
    sensor_id = Sensor.id(pid)

    %{name: Atom.to_string(sensor_id),
      value: Sensor.value(pid)}
  end

  defp build_stat_resp(stat) do
    %{value: stat.value,
      inserted_at: stat.inserted_at}
  end
end
