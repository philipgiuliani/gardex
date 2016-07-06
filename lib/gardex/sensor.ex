defmodule Gardex.Sensor do
  use GenServer
  require Logger

  defmodule State do
    defstruct sensor: nil, dry: false
  end

  def start_link(pin) do
    GenServer.start_link(__MODULE__, pin, name: __MODULE__)
  end

  def init(pin) do
    {:ok, pid} = Gpio.start_link(pin, :input)

    Logger.debug "Initialized sensor"

    state = %State{sensor: pid, dry: Gpio.read(pid) == 1}
    :ok = Gpio.set_int pid, :both

    {:ok, state}
  end

  def dry?(pid), do: GenServer.call(pid, :dry)

  def handle_info({:gpio_interrupt, _, :rising}, state) do
    Logger.debug "Handle rising callback"
    state = %{state | dry: true}

    {:noreply, state}
  end

  def handle_info({:gpio_interrupt, _, :falling}, state) do
    Logger.debug "Handle falling callback"
    state = %{state | dry: false}

    {:noreply, state}
  end

  def handle_call(:dry, _from, state) do
    {:reply, state.dry, state}
  end

  def terminate(_reason, state) do
    Logger.debug "Terminating"

    Gpio.release state.sensor
  end
end
