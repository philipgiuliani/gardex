defmodule Gardex do
  use Application

  alias Gardex.MoistureSensor
  alias Gardex.Pot
  alias Gardex.PotMonitor
  alias Gardex.Pump

  def start(_type, _args) do
    {:ok, moisture_pid} = MoistureSensor.start_link(17)
    {:ok, pump_pid} = Pump.start_link(27)

    chilli_pot = %Pot{
      name: "Habanero",
      moisture_sensor: moisture_pid,
      hydrator: pump_pid}

    {:ok, _} = PotMonitor.start_link(chilli_pot)

    {:ok, self}
  end
end
