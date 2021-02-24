defmodule Ping.Checks.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_check_to_supervisor(%Ping.Checks.Check{} = check) do
    child_spec = %{
      id: Ping.Checks.Actor,
      start: {Ping.Checks.Actor, :start_link, [check]},
      restart: :transient
    }

    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
