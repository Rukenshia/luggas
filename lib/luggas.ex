defmodule Luggas do
    def start_link() do
      {:ok, _} = Plug.Adapters.Cowboy.http(Luggas.Router, [])
    end

    def init(_opts), do: nil
  end
