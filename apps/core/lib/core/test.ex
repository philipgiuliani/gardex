defmodule Core.Test do
  use GenServer
  require Logger

  alias Core.Sensor

  def start_link(sensor, opts \\ []) do
    GenServer.start_link(__MODULE__, sensor, opts)
  end

  def init(sensor) do
    schedule()

    {:ok, sensor}
  end

  # Callbacks

  def handle_info(:monitor, state) do
    value = Sensor.value(state)
    Logger.debug "Sensor value: #{value}"

    schedule()
    {:noreply, state}
  end

  def schedule do
    Process.send_after(self(), :monitor, 1_000)
  end
end
