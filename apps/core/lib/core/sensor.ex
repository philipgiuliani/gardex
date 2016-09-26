defmodule Core.Sensor do
  use GenServer
  require Logger

  @iterations 8

  defmodule State do
    defstruct id: nil, address: nil
  end

  # Public API
  def start_link(name, address) do
    state = %State{address: address, id: name}

    GenServer.start_link(__MODULE__, state, [name: name])
  end

  def value(pid), do: GenServer.call(pid, :value)

  def id(pid), do: GenServer.call(pid, :id)

  # Callbacks
  def init(state), do: {:ok, state}

  def handle_call(:id, _from, %{id: id} = state) do
    {:reply, id, state}
  end

  def handle_call(:value, _from, %{address: address} = state) do
    result = read_sensor(address)
    {:reply, result, state}
  end

  # Internal
  defp read_sensor(address), do: read_sensor(address, 0, 0)
  defp read_sensor(address, sum, iterations) when iterations < @iterations do
    <<_::size(14), result::size(10)>> = Spi.transfer(:spi, <<1, address, 0>>)
    read_sensor(address, sum + result, iterations + 1)
  end
  defp read_sensor(_, sum, _), do: sum / @iterations
end
