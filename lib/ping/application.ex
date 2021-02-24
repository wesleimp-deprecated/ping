defmodule Ping.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Ping.Checks

  @checks_actor [
    Checks.Registry.child_spec(),
    Checks.DynamicSupervisor,
    Checks.StateHydrator
  ]

  @impl true
  def start(_type, _args) do
    children = [] ++ @checks_actor

    opts = [strategy: :one_for_one, name: Ping.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
