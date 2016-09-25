defmodule Core.Pump do
  @behaviour Core.Irrigator

  require Logger

  def start() do
    Logger.debug "Pump start"
  end
end
