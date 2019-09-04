defmodule WebServer.Router do
  use Plug.Router
  plug(Plug.Logger)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/publish/:message" do
    message = Map.get(conn.params, "message", "No Message Provided")
    spawn(fn -> to_string(:inet_parse.ntoa(conn.remote_ip)) |> process_new_activity(message) end)
    send_resp(conn, 200, "Welcome")
  end

  defp process_new_activity(ip_address, name) when is_binary(name) do
    QueueServer.publish(:queue_server, :log, name)
    QueueServer.publish(:queue_server, :telemetry, ip_address)
    Jason.encode!(%{message: "activity saved"})
  end

  defp missing_name do
    Jason.encode!(%{message: "activity name missing"})
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
