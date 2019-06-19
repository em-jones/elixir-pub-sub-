defmodule WebServer.Router do
  use Plug.Router
  plug(Plug.Logger)
  plug(:match)
  plug Plug.Parsers,
       parsers: [:urlencoded, :multipart, :json],
       pass: ["*/*"],
       json_decoder: Jason
  plug(:dispatch)

  get "/publish/:message" do
    message = Map.get(conn.params, "message", "No Message Provided")
    QueueServer.publish :queue1, message
    send_resp(conn, 200, "Welcome")
  end

  post "/activity" do
    {status, body} =
      case conn.body_params do
        %{"name" => name} -> {200, process_new_activity(name)}
        _ -> {422, missing_name()}
      end
    send_resp(conn, status, body)
  end

  defp process_new_activity(name) when is_binary(name) do
    QueueServer.publish :feelz_create, name
    Jason.encode! %{message: "activity saved"}
  end
  defp missing_name do
    Jason.encode! %{message: "activity name missing"}
  end
  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
