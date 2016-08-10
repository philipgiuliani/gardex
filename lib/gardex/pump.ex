defmodule Gardex.Pump do
  use GenServer
  require Logger

  defmodule State do
    defstruct pump: nil, running: false
  end

  def start_link(pin, opts \\ []) do
    GenServer.start_link(__MODULE__, pin, opts)
  end

  def start(pid), do: GenServer.cast(pid, :start)

  def stop(pid), do: GenServer.cast(pid, :stop)

  def running?(pid), do: GenServer.call(pid, :running)

  def init(pin) do
    {:ok, pid} = Gpio.start_link(pin, :output)

    Logger.debug "Initialized pump"

    state = %State{pump: pid, running: false}

    {:ok, state}
  end

  # Callbacks

  def handle_call(:running, _from, state) do
    {:reply, state.running, state}
  end

  def handle_cast(:start, state) do
    Gpio.write(state.pump, 1)

    state = %State{state | running: true}
    {:noreply, state}
  end

  def handle_cast(:stop, state) do
    Gpio.write(state.pump, 0)

    state = %State{state | running: false}
    {:noreply, state}
  end

  def terminate(_reason, state) do
    Gpio.release state.pump
  end
end
