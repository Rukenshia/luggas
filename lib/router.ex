defmodule Luggas.Router do
  use Plug.Router
  use Plug.ErrorHandler

  require Logger

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Poison

  plug :match
  plug :dispatch

  post "/_telegram" do
    {:ok, p2} = Elastix.Document.index("http://127.0.0.1:9200", "luggas", "webhook", conn.body_params["update_id"], Map.put(conn.body_params, "timestamp", :os.system_time(:seconds)))

    if p2.status_code != 200 && p2.status_code != 201 do
      IO.inspect p2
      send_resp(conn, p2.status_code, Poison.encode!(%{"ok": false}))
    else
      Logger.info "webhook with update #{conn.body_params["update_id"]} saved"

      send_resp(conn, 200, Poison.encode!(%{"ok": true}))
    end
  end

  match _ do
    send_resp(conn, 400, Poison.encode!(%{"ok": false}))
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect kind
    IO.inspect reason
    IO.inspect stack

    send_resp(conn, conn.status, Poison.encode!(%{"ok": false}))
  end
end
