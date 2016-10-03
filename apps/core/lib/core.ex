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
    Core.SensorSupervisor.start_sensor(id: :moisture, address: 0x80)
    Core.SensorSupervisor.start_sensor(id: :temperature, address: 0x90, converter: Core.Converters.TMP36)
    Core.SensorSupervisor.start_sensor(id: :light, address: 0xA0)

    # Setup Pots
    Core.PotSupervisor.start_pot("Chilli", [:moisture, :temperature, :light])

    {:ok, self}
  end

  def get_pots() do
    Supervisor.which_children(Core.PotSupervisor)
    |> extract_pid_from_children
  end

  def get_sensors() do
    Supervisor.which_children(Core.SensorSupervisor)
    |> extract_pid_from_children
  end

  defp extract_pid_from_children(children) do
    Enum.map(children, fn {_, pid, _, _} -> pid end)
  end
end
