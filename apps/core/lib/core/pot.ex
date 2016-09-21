defmodule Core.Pot do
  use GenServer

  defmodule State do
    defstruct name: nil, sensors: []
  end

  def name(pid), do: GenServer.call(pid, :name)

  def sensors(pid), do: GenServer.call(pid, :sensors)

  # Public API
  def start_link(name, sensors) do
    GenServer.start_link(__MODULE__, [name, sensors], [])
  end

  # Internal API
  def init([name, sensors]) do
    state = %State{name: name, sensors: sensors}
    {:ok, state}
  end

  def handle_call(:name, _from, state) do
    {:reply, state.name, state}
  end

  def handle_call(:sensors, _from, state) do
    {:reply, state.sensors, state}
  end
end
