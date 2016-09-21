defmodule Core.PotTest do
  use ExUnit.Case
  alias Core.Pot

  test "starting the pot" do
    assert {:ok, _pid} = Pot.start_link("Chilli", [])
  end
end
