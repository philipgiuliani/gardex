defmodule Core.PotSupervisor do
  use Supervisor

  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def start_pot(name, sensors) do
    Supervisor.start_child(@name, [name, sensors])
  end

  def init(_) do
    children = [
      worker(Core.Pot, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
