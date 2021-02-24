defmodule Ping.Checks do
  alias Ping.Checks.Check

  def list do
    [
      %Check{id: 1, endpoint: "https://google.com", method: "get", time: 5000},
      %Check{id: 2, endpoint: "https://facebook.com", method: "get", time: 10000},
      %Check{id: 3, endpoint: "https://aol.com", method: "get", time: 1000},
      %Check{id: 4, endpoint: "https://api.github.com/invalid", method: "get", time: 8000}
    ]
  end
end
