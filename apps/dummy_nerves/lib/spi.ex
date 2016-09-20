defmodule Spi do
  use GenServer

  @moduledoc """
  Stand in for Elixir Ale's Spi in development and test mode
  """

  defmodule State do
    defstruct devname: nil
  end

  # Public API
  def start_link(devname, spi_opts \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, {devname, spi_opts}, opts)
  end

  def release(pid) do
    GenServer.cast pid, :release
  end

  def transfer(pid, data) do
    GenServer.call pid, {:transfer, data}
  end

  # Callbacks

  def init({devname, _spi_opts}) do
    state = %State{devname: devname}
    {:ok, state}
  end

  def handle_call({:transfer, _data}, _from, state) do
    {:reply, <<0::size(14), 500::size(10)>>, state}
  end

  def handle_cast(:release, state) do
    {:stop, :normal, state}
  end
end
