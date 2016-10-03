defmodule Core.Pot do
  use GenServer

  defmodule State do
    defstruct name: nil, sensors: []
  end

  # Public API
  def start_link(name, sensors) do
    GenServer.start_link(__MODULE__, [name, sensors], [])
  end

  def name(pid), do: GenServer.call(pid, :name)

  def sensors(pid), do: GenServer.call(pid, :sensors)

  # Callbacks
  def init([name, sensors]) do
    schedule()

    state = %State{name: name, sensors: sensors}
    {:ok, state}
  end

  def handle_call(:name, _from, state) do
    {:reply, state.name, state}
  end

  def handle_call(:sensors, _from, state) do
    {:reply, state.sensors, state}
  end

  # Internal
  def handle_info(:monitor, state) do
    # TODO

    schedule()
    {:noreply, state}
  end

  defp schedule() do
    Process.send_after(self(), :monitor, 1_000)
  end
end
