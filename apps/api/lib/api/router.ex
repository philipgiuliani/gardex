defmodule Api.Router do
  use Plug.Router

  alias Core.Pot
  alias Core.Sensor

  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/pots" do
    pots =
      Core.get_pots()
      |> extract_pids
      |> Enum.map(&build_pot_resp(&1))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{pots: pots}))
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp extract_pids(children) do
    Enum.map children, fn {_, pid, _, _} -> pid end
  end

  defp build_pot_resp(pid) do
    name = Pot.name(pid)
    sensors = Pot.sensors(pid)

    %{
      name: name,
      sensors: Enum.map(sensors, &build_sensor_resp(&1))
    }
  end

  defp build_sensor_resp(pid) do
    %{
      name: Atom.to_string(pid),
      value: Sensor.value(pid)
    }
  end
end
