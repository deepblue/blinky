defmodule Blinky.Blink do
  use GenServer
  require Logger
  alias Nerves.Leds

  def start_link(state \\ 1000, opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, state, opts)
    GenServer.cast(pid, {:blink})
    {:ok, pid}
  end

  def handle_cast({:set, new_state}, state) do
    Logger.info "State change: #{state} => #{new_state}"

    {:noreply, new_state}
  end


  def handle_cast({:blink}, state) do
    Logger.info "blink #{state}"

    Leds.set green: true
    :timer.sleep(state)
    Leds.set green: false

    GenServer.cast(self(), {:blink})

    {:noreply, state}
  end


end
