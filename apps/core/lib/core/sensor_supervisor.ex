defmodule Core.SensorSupervisor do
  use Supervisor

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def start_sensor(opts) do
    Supervisor.start_child(@name, [opts])
  end

  def init(_) do
    children = [
      worker(Core.Sensor, [], restart: :permanent)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
