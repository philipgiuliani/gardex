defmodule Gardex do
  alias Nerves.Leds
  alias Gardex.Sensor
  require Logger

  def start(_type, _args) do
    {:ok, pid} = Sensor.start_link(17)
    spawn fn -> monitor_sensor(pid) end
    {:ok, self}
  end

  def monitor_sensor(pid) do
    if Sensor.dry?(pid) do
      Leds.set [{:green, false}]
      Leds.set [{:red, false}]
    else
      Leds.set [{:green, true}]
      Leds.set [{:red, true}]
    end

    monitor_sensor(pid)
  end
end
