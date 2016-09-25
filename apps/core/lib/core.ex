defmodule Core do
  use Application

  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Spi, ["spidev0.0", [], [name: :spi]]),

      supervisor(Core.SensorSupervisor, []),
      supervisor(Core.PotSupervisor, [])
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])

    ### This part will be handled by a configuration

    # Setup Sensors
    Core.SensorSupervisor.start_sensor(:moisture, 0x80)
    Core.SensorSupervisor.start_sensor(:temperature, 0x90)
    Core.SensorSupervisor.start_sensor(:light, 0xA0)

    # Setup Pots
    Core.PotSupervisor.start_pot("Chilli", [:moisture, :temperature, :light])

    {:ok, self}
  end

  def get_pots() do
    Supervisor.which_children(Core.PotSupervisor)
    |> Enum.map(fn {_, pid, _, _} -> pid end)
  end
end
