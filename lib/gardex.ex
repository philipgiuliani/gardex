defmodule Gardex do
  use Application

  alias Gardex.MoistureSensor
  alias Gardex.Pot
  alias Gardex.PotMonitor
  alias Gardex.Pump

  def start(_type, _args) do
    import Supervisor.Spec

    sensors = [
      worker(MoistureSensor, [17, [name: :moisture_one]], id: make_ref()),
      worker(MoistureSensor, [22, [name: :moisture_two]], id: make_ref()),
      worker(Pump, [27, [name: :pump]], id: make_ref())
    ]

    monitors = [
      worker(PotMonitor, [%Pot{name: "Chilli", moisture_sensor: :moisture_one, hydrator: :pump}], id: make_ref()),
      worker(PotMonitor, [%Pot{name: "Paprika", moisture_sensor: :moisture_two, hydrator: :pump}], id: make_ref())
    ]

    Supervisor.start_link(sensors, [strategy: :one_for_one])
    Supervisor.start_link(monitors, [strategy: :one_for_one])

    {:ok, self}
  end
end
