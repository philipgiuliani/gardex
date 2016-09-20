defmodule Nerves.InterimWiFi do
  use GenServer

  @moduledoc """
  Fakes interim wifi; does nothing.
  """

  def setup interface, opts \\ [] do
    GenServer.start_link(__MODULE__, {interface, opts}, [name: :interim_wifi])
  end
end
