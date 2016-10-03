defmodule Core.Converters.TMP36Test do
  use ExUnit.Case
  alias Core.Converters.TMP36

  describe "convert/1" do
    test "converts an analogue value to a temperature" do
      assert TMP36.convert(0) == -50
      assert TMP36.convert(1024) == 280
    end
  end
end
