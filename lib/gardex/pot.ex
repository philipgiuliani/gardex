defmodule Gardex.Pot do
  defstruct name: nil, moisture: nil, temperature: nil, light: nil

  alias Gardex.Sensor

  def needs_water?(pot) do
    Sensor.value(pot.moisture) > 500 && Sensor.value(pot.light) > 500
  end
end
