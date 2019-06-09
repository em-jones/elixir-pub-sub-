defmodule WebServer.Router do
  use Plug.Router
  plug(:match)
  plug(:dispatch)

  get "/publish/:message" do
    message = Map.get(conn.params, "message", "No Message Provided")
    QueueServer.publish :queue1, message
    send_resp(conn, 200, "Welcome")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
