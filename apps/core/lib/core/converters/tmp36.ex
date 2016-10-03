defmodule Core.Converters.TMP36 do
  @behaviour Core.Converter

  def convert(value) do
    voltage = value * (3300 / 1024)
    (voltage - 500) / 10
  end
end
