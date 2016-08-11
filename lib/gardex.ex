defmodule Gardex do
  use Application

  alias Gardex.Sensor
  alias Gardex.Pump
  alias Gardex.Pot
  alias Gardex.Monitor

  def start(_type, _args) do
    import Supervisor.Spec

    sensors = [
      worker(Spi, ["spidev0.0", [], [name: :spi]]),

      # Inputs
      worker(Sensor, [0x80, [name: :moisture]], id: make_ref()),
      worker(Sensor, [0x90, [name: :temperature]], id: make_ref()),
      worker(Sensor, [0xA0, [name: :light]], id: make_ref()),

      # Outputs
      worker(Pump, [17, [name: :pump]], id: make_ref())
    ]

    pots = [
      %Pot{name: "Chilli", moisture: :moisture, temperature: :temperature, light: :light},
      %Pot{name: "Paprika", moisture: :moisture, temperature: :temperature, light: :light}
    ]

    monitors = [
      worker(Monitor, [%{pump: :pump, pots: pots}], id: make_ref())
    ]

    # Start everything up
    Supervisor.start_link(sensors, [strategy: :one_for_one])
    Supervisor.start_link(monitors, [strategy: :one_for_one])

    {:ok, self}
  end
end
