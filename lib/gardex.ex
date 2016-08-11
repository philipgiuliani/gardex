defmodule Gardex do
  use Application
  use Bitwise

  alias Gardex.MoistureSensor
  alias Gardex.Pot
  alias Gardex.PotMonitor
  alias Gardex.Pump

  import Logger

  def start(_type, _args) do
    import Supervisor.Spec

    # sensors = [
    #   worker(MoistureSensor, [17, [name: :moisture_one]], id: make_ref()),
    #   worker(MoistureSensor, [22, [name: :moisture_two]], id: make_ref()),
    #   worker(Pump, [27, [name: :pump]], id: make_ref())
    # ]

    # monitors = [
    #   worker(PotMonitor, [%Pot{name: "Chilli", moisture_sensor: :moisture_one, hydrator: :pump}], id: make_ref()),
    #   worker(PotMonitor, [%Pot{name: "Paprika", moisture_sensor: :moisture_two, hydrator: :pump}], id: make_ref())
    # ]

    # Supervisor.start_link(sensors, [strategy: :one_for_one])
    # Supervisor.start_link(monitors, [strategy: :one_for_one])

    {:ok, pid} = Spi.start_link("spidev0.0")

    read_value(pid)

    {:ok, self}
  end

  def read_value(pid) do
    # CH0 = 1 0 0 0
    # CH1 = 1 0 0 1
    # CH2 = 1 0 1 0

    <<_::size(14), moisture::size(10)>> = Spi.transfer(pid, <<1, 128, 0>>)
    <<_::size(14), temperature::size(10)>> = Spi.transfer(pid, <<1, 144, 0>>)
    <<_::size(14), light::size(10)>> = Spi.transfer(pid, <<1, 160, 0>>)

    millivolts = temperature * (3.3 / 1024.0)
    Logger.debug "Temperature in °C: #{(millivolts - 0.5) * 100}"
    Logger.debug "Moisture: #{moisture}"
    Logger.debug "Light: #{light}"

    Process.sleep(500)

    read_value(pid)
  end
end
