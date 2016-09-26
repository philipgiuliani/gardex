defmodule Stats.Monitor do
  use GenServer

  alias Core.Sensor
  require Logger

  @interval 1 * 60 * 1000

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule()
    {:ok, state}
  end

  def handle_info(:collect, state) do
    Core.get_sensors()
    |> write_to_database

    schedule()
    {:noreply, state}
  end

  defp write_to_database([]), do: :ok
  defp write_to_database([pid | tail]) do
    stat = %Stats.Stat{
      sensor_id: Atom.to_string(Sensor.id(pid)),
      value: Sensor.value(pid)
    }

    Stats.Repo.insert!(stat)

    Logger.debug "Stats - Added #{stat.value} for sensor #{stat.sensor_id}"

    write_to_database(tail)
  end

  defp schedule() do
    Logger.debug "Stats - Scheduling work"
    Process.send_after(self(), :collect, @interval)
  end
end
