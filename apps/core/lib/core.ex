defmodule Core do
  use Application
  
  require Logger

  alias Core.Sensor
  alias Core.Test

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Spi, ["spidev0.0", [], [name: :spi]]),
      worker(Sensor, [0x80, [name: :moisture]], id: make_ref()),
      worker(Test, [:moisture], id: make_ref())
    ]
    
    Supervisor.start_link(children, [strategy: :one_for_one, name: Core.Supervisor])

    {:ok, self}
  end
end
