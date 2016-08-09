defmodule Gardex.PotMonitor do
  use GenServer
  require Logger

  alias Gardex.MoistureSensor
  alias Gardex.Pump

  defmodule State do
    defstruct pot: nil
  end

  def start_link(pot) do
    GenServer.start_link(__MODULE__, pot, [])
  end

  def init(pot) do
    Logger.debug "#{pot.name}: Starting Monitoring"
    schedule()
    {:ok, %State{pot: pot}}
  end

  # Callbacks

  def handle_info(:monitor, state) do
    Logger.debug "#{state.pot.name} Status:"

    if MoistureSensor.dry?(state.pot.moisture_sensor) do
      Pump.start(state.pot.hydrator)
    else
      Pump.stop(state.pot.hydrator)
    end

    schedule()
    {:noreply, state}
  end

  def schedule do
    Process.send_after(self(), :monitor, 10_000)
  end
end
