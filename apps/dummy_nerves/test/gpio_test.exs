defmodule GpioTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Gpio.start_link(6, :output)
    {:ok, pin6: pid}
  end

  test "reading and writing", %{pin6: pin6} do
    assert 0 == Gpio.read(pin6)
    Gpio.write(pin6, 1)
    assert 1 == Gpio.read(pin6)
    Gpio.write(pin6, 0)
    assert 0 == Gpio.read(pin6)
  end

  test 'logging', %{pin6: pin6} do
    assert [] == Gpio.pin_state_log(pin6)
    Gpio.write(pin6, 1)
    Gpio.write(pin6, 0)
    Gpio.write(pin6, 0)
    Gpio.write(pin6, 1)
    Gpio.write(pin6, 0)
    assert [1, 0, 0, 1, 0] == Gpio.pin_state_log(pin6)
  end

  test "asking for the same pin twice", %{pin6: pin6} do
    # For neatness, each dummy Gpio is by default named after the pin which
    # could cause issues if a pin is used in different parts of the app.
    {:ok, pin6clone} = Gpio.start_link(6, :input)
    {:ok, pin7} = Gpio.start_link(7, :input)

    assert pin6 == pin6clone
    assert pin6 == Process.whereis(:gpio_6)
    refute pin7 == pin6
  end
end
