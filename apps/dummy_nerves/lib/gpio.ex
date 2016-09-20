defmodule Gpio do
  use GenServer

  @moduledoc """
  Stand in for Elixir Ale's Gpio in development and test mode
  """

  defstruct pin: 0, direction: nil, pin_states: []

  def start_link(pin, direction, supplied_opts \\ nil) do
    opts = supplied_opts || [name: :"gpio_#{pin}"]
    case Process.whereis(opts[:name]) do
      nil -> GenServer.start_link(__MODULE__, {pin, direction}, opts)
      pid -> {:ok, pid}
    end
  end

  @doc """
  Just change the value of the 'pin' to the value. Can be read by #read/2
  """
  def write(pid, value) do
    GenServer.call(pid, {:write, value})
  end

  @doc """
  Read the value of the pin. Can be set by #write/1. Defaults to zero.
  """
  def read(pid) do
    GenServer.call(pid, :read)
  end

  @doc """
  List of the values written to the the pin in order:
  the first is the head. Does not include the initial default value.
  """
  def pin_state_log(pid) do
    GenServer.call(pid, :pin_state_log)
  end

  @doc """
  Resets the pin state to 0 and the pin_state_log to empty
  """
  def reset_pin_states(pid) do
    GenServer.call(pid, :reset_pin_states)
  end

  # Genserver
  def init({pin, direction}) do
    state = %Gpio{pin: pin, direction: direction}
    {:ok, state}
  end

  def handle_call({:write, value}, _from, state) do
    new_state = state |> Map.update!(:pin_states, &([value | &1]))
    {:reply, :ok, new_state} #todo - what should the actual reply be?
  end

  def handle_call(:read, _from, state = %{pin_states: [pin_state | _]}) do
    {:reply, pin_state, state}
  end

  def handle_call(:read, _from, state = %{pin_states: []}) do
    {:reply, 0, state}
  end

  def handle_call(:pin_state_log, _from, state) do
    log = state.pin_states |> Enum.reverse
    {:reply, log, state}
  end

  def handle_call(:reset_pin_states, _from, state) do
    new_state = state |> Map.put(:pin_states, [])
    {:reply, :ok, new_state}
  end
end
