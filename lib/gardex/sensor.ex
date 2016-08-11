defmodule Gardex.Sensor do
  use GenServer

  def start_link(channel, opts \\ []) do
    GenServer.start_link(__MODULE__, channel, opts)
  end

  def init(channel) do
    {:ok, channel}
  end

  def value(pid), do: GenServer.call(pid, :value)

  # Callbacks

  def handle_call(:value, _from, state) do
    <<_::size(14), value::size(10)>> = Spi.transfer(:spi, <<1, state, 0>>)

    {:reply, value, state}
  end
end
