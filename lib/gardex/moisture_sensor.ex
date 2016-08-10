defmodule Gardex.MoistureSensor do
  use GenServer
  require Logger

  defmodule State do
    defstruct sensor: nil, dry: false
  end

  def start_link(pin, opts \\ []) do
    GenServer.start_link(__MODULE__, pin, opts)
  end

  def dry?(pid), do: GenServer.call(pid, :dry)

  def init(pin) do
    {:ok, pid} = Gpio.start_link(pin, :input)

    Logger.debug "Moisture Sensor on pin ##{pin} initialized"

    state = %State{sensor: pid, dry: Gpio.read(pid) == 1}
    :ok = Gpio.set_int pid, :both

    {:ok, state}
  end

  # Callbacks

  def handle_info({:gpio_interrupt, _, :rising}, state) do
    Logger.debug "Moisture: rising sensor value"
    state = %{state | dry: true}

    {:noreply, state}
  end

  def handle_info({:gpio_interrupt, _, :falling}, state) do
    Logger.debug "Moisture: falling sensor value"
    state = %{state | dry: false}

    {:noreply, state}
  end

  def handle_call(:dry, _from, state) do
    {:reply, state.dry, state}
  end

  def terminate(_reason, state) do
    Gpio.release state.sensor
  end
end
