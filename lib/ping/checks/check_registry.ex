defmodule Ping.Checks.Registry do
  def child_spec do
    Registry.child_spec(
      keys: :unique,
      name: __MODULE__,
      partitions: System.schedulers_online()
    )
  end

  def lookup_site(check_id) do
    case Registry.lookup(__MODULE__, check_id) do
      [{check_pid, _}] ->
        {:ok, check_pid}

      [] ->
        {:error, :not_found}
    end
  end
end
