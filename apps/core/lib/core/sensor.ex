defmodule Core.Sensor do
  use GenServer
  require Logger

  @iterations 8

  defmodule State do
    defstruct id: nil, address: nil, converter: nil
  end

  # Public API

  def start_link(opts) do
    id = Keyword.get(opts, :id)
    GenServer.start_link(__MODULE__, opts, [name: id])
  end

  def value(pid), do: GenServer.call(pid, :value)

  def id(pid), do: GenServer.call(pid, :id)

  # Callbacks

  def init(opts) do
    address = Keyword.get(opts, :address)
    id = Keyword.get(opts, :id)
    converter = Keyword.get(opts, :converter)

    {:ok, %State{address: address, id: id, converter: converter}}
  end

  def handle_call(:id, _from, %{id: id} = state) do
    {:reply, id, state}
  end

  def handle_call(:value, _from, %{address: address} = state) do
    result =
      address
      |> read_sensor()
      |> convert_value(state.converter)

    {:reply, result, state}
  end

  # Internal

  defp read_sensor(address), do: read_sensor(address, 0, 0)
  defp read_sensor(address, sum, iterations) when iterations < @iterations do
    <<_::size(14), result::size(10)>> = Spi.transfer(:spi, <<1, address, 0>>)
    read_sensor(address, sum + result, iterations + 1)
  end
  defp read_sensor(_, sum, _), do: sum / @iterations

  defp convert_value(value, nil), do: value / 1
  defp convert_value(value, converter), do: converter.convert(value) / 1
end
