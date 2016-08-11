defmodule Gardex.Monitor do
  use GenServer
  require Logger

  alias Gardex.Pot
  alias Gardex.Pump
  alias Gardex.Sensor

  defmodule State do
    defstruct pump: nil, pots: nil
  end

  def start_link(data, opts \\ []) do
    GenServer.start_link(__MODULE__, data, opts)
  end

  def init(data) do
    schedule()

    {:ok, %State{pots: data.pots, pump: data.pump}}
  end

  # Callbacks

  def handle_info(:monitor, state) do
    needs_water = Enum.any?(state.pots, &Pot.needs_water?(&1))
    pump_running = Pump.running?(state.pump)

    # Log pots
    Enum.each(state.pots, fn pot ->
      Logger.debug "Pot #{pot.name} -> Light: #{Sensor.value(pot.light)}, Moisture: #{Sensor.value(pot.moisture)}, Temperature: #{Sensor.value(pot.temperature)}"
    end)

    # Handle watering
    case {needs_water, pump_running} do
      {true, false} ->
        Logger.debug "Some plant wants water"
        Pump.start(state.pump)
      {false, true} ->
        Logger.debug "Plants are happy now"
        Pump.stop(state.pump)
      _ -> true
    end

    schedule()
    {:noreply, state}
  end

  def schedule do
    Process.send_after(self(), :monitor, 1_000)
  end
end
