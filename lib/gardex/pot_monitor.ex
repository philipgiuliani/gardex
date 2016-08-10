defmodule Gardex.PotMonitor do
  use GenServer
  require Logger

  alias Gardex.MoistureSensor
  alias Gardex.Pump

  defmodule State do
    defstruct pot: nil
  end

  def start_link(pot, opts \\ []) do
    GenServer.start_link(__MODULE__, pot, opts)
  end

  def init(pot) do
    Logger.debug "#{pot.name}: Starting Monitoring"
    schedule()

    {:ok, %State{pot: pot}}
  end

  # Callbacks

  def handle_info(:monitor, state) do
    moisture_dry = MoistureSensor.dry?(state.pot.moisture_sensor)
    pump_running = Pump.running?(state.pot.hydrator)

    case {moisture_dry,pump_running} do
      {true, false} ->
        Logger.debug "#{state.pot.name} is dry. Starting to hydrate"
        Pump.start(state.pot.hydrator)
      {false, true} ->
        Logger.debug "#{state.pot.name} is wet. Stopping hydrator"
        Pump.stop(state.pot.hydrator)
      _ -> Logger.debug "#{state.pot.name} is happy"
    end

    schedule()
    {:noreply, state}
  end

  def schedule do
    Process.send_after(self(), :monitor, 1_000)
  end
end
