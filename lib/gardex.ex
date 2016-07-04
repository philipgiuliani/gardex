defmodule Gardex do
  alias Nerves.Leds

  def start(_type, _args) do
    {:ok, pid} = Gpio.start_link(17, :input)
    spawn fn -> monitor_sensor(pid) end

    {:ok, self}
  end

  def monitor_sensor(pid) do
    if Gpio.read(pid) == 1 do
      Leds.set [{:green, true}]
      Leds.set [{:red, true}]
    else
      Leds.set [{:green, false}]
      Leds.set [{:red, false}]
    end

    monitor_sensor(pid)
  end
end
