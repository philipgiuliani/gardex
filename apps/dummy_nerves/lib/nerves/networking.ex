defmodule Nerves.Networking do
  require Logger
  use GenServer


  @name :dummy_ethernet

  @moduledoc """
  Does nothing. Stands in for https://github.com/nerves-project/nerves_io_ethernet
  during development. Partial implementation for now.
  """

  def setup interface, opts \\ [] do
    GenServer.start_link(__MODULE__, {interface, opts}, [name: @name])
  end

  @doc """
  Kill the ethernet. Useful if you want to check resilience
  """
  def crash do
    GenServer.call(@name, :crash)
  end


  def init(_args) do
    if Application.get_env(:saxophone, :kill_dummy_ethernet) do
      send(self, :crash)
    end
    {:ok, []}
  end

  def handle_call(:crash, _from, state) do
    send(self, :crash)
    {:reply, :ok, state}
  end

  def handle_info(:crash, state) do
    Logger.info("Ethernet crashing")
    {:noreply, :kill, state}
  end
end
