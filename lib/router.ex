defmodule Luggas.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Poison

  plug :match
  plug :dispatch

  post "/_telegram" do
    {:ok, p2} = Elastix.Document.index("http://127.0.0.1:9200", "luggas", "webhook", conn.body_params["update_id"], conn.body_params)

    if p2.status_code != 200 do
      send_resp(conn, p2.status_code, Poison.encode!(p2))
    else
      send_resp(conn, 200, Poison.encode!(%{"ok" => true}))
    end
  end

  match _ do
    send_resp(conn, 400, "Client Error")
  end

  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    IO.inspect _reason
    IO.inspect _stack
    send_resp(conn, conn.status, "Something went wrong")
  end
end
