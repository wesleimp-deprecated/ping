defmodule Ping.Checks.StateHydrator do
  use GenServer, restart: :transient

  alias Ping.Checks

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__, timeout: 10_000)
  end

  @impl true
  def init(_) do
    Ping.Checks.list()
    |> Enum.each(&Checks.DynamicSupervisor.add_check_to_supervisor/1)

    :ignore
  end
end
