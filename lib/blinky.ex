defmodule Blinky do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    Logger.info "Setting WIFI #{inspect(Application.get_env(:blinky, :wifi, []))}"
    Logger.debug inspect(Nerves.InterimWiFi.setup "wlan0", Application.get_env(:blinky, :wifi, []))

    # Define workers and child supervisors to be supervised
    children = [
      worker(Blinky.Blink, [1000, [name: :blink]]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blinky.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
