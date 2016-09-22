defmodule Core.Sensor do
  use GenServer
  require Logger

  @iterations 8

  def start_link(name, address) do
    GenServer.start_link(__MODULE__, address, [name: name])
  end

  def init(address), do: {:ok, address}

  def value(pid), do: GenServer.call(pid, :value)

  # Callbacks

  def handle_call(:value, _from, address) do
    result = read_sensor(address)
    {:reply, result, address}
  end

  # Internal

  defp read_sensor(address), do: read_sensor(address, 0, 0)
  defp read_sensor(address, sum, iterations) when iterations < @iterations do
    <<_::size(14), result::size(10)>> = Spi.transfer(:spi, <<1, address, 0>>)
    read_sensor(address, sum + result, iterations + 1)
  end
  defp read_sensor(_, sum, _), do: sum / @iterations
end
