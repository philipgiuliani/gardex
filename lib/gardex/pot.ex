defmodule Gardex.Pot do
  defstruct name: nil, moisture: nil, temperature: nil, light: nil

  alias Gardex.SpiSensor

  def needs_water?(pot) do
    SpiSensor.value(pot.moisture) > 500
  end
end
