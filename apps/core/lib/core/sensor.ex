defmodule Core.Sensor do
  use GenServer

  def start_link(name, address) do
    GenServer.start_link(__MODULE__, address, [name: name])
  end

  def init(address), do: {:ok, address}

  def value(pid), do: GenServer.call(pid, :value)

  # Callbacks

  def handle_call(:value, _from, address) do
    <<_::size(14), result::size(10)>> = Spi.transfer(:spi, <<1, address, 0>>)

    {:reply, result, address}
  end
end
