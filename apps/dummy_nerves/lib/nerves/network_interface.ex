defmodule Nerves.NetworkInterface do
  @moduledoc """
  In case you're listening for (interim wifi) events.
  """
  def event_manager do
    case GenEvent.start_link do
      {:ok, pid} -> pid
    end
  end
end
