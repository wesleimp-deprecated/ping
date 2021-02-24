defmodule Ping.Checks.Actor do
  use GenServer

  require Logger

  defmodule State do
    defstruct [:check, :success_count, :fail_count]
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state,
      name: {:via, Registry, {Ping.Checks.Registry, state.id}}
    )
  end

  def init(%{time: time} = check) do
    schedule_check(time)
    {:ok, %State{check: check, success_count: 0, fail_count: 0}}
  end

  def handle_info(:ping, %{check: check} = state) do
    state =
      do_request(check)
      |> process_response()
      |> update_count(state)

    Logger.info("Checking #{check.endpoint}",
      success_count: state.success_count,
      fail_count: state.fail_count
    )

    schedule_check(check.time)

    {:noreply, state}
  end

  defp do_request(%{endpoint: endpoint, method: method}) do
    String.to_atom(method)
    |> HTTPoison.request(endpoint)
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: status_code}})
       when status_code >= 200 and status_code < 400 do
    :success
  end

  defp process_response({:ok, %HTTPoison.Response{} = _response}) do
    :fail
  end

  defp update_count(:success, %{success_count: success_count} = state),
    do: %State{state | success_count: success_count + 1}

  defp update_count(:fail, %{fail_count: fail_count} = state),
    do: %State{state | fail_count: fail_count + 1}

  defp schedule_check(time) do
    Process.send_after(self(), :ping, time)
  end
end
