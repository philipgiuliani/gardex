defmodule Core.SensorTest do
  use ExUnit.Case
  alias Core.Sensor

  test "starting the sensor" do
    assert {:ok, _pid} = Sensor.start_link(:name, 0x80)
  end

  test "value/1 reads the sensor" do
    {:ok, pid} = Sensor.start_link(:name, 0x80)
    assert Sensor.value(pid) == 500
  end
end
