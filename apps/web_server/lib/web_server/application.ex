defmodule WebServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: WebServer.Worker.start_link(arg)
      # {WebServer.Worker, arg}
      {
        Plug.Cowboy,
        scheme: :http,
        plug: WebServer.Router,
        options: [
          port: 8000
        ]
      }
    ]

    Logger.info("Starting application...")

    {:ok, _} = Registry.start_link(keys: :unique, name: Registry.PubSubTest)

    queue_server = QueueServer.start # create our microservice's queue server
    Process.register(queue_server, :queue_server) # register it against a name

    spawn(QueueServer, :subscribe, [queue_server, :log, QueueServer.create_handler(&(IO.puts("Log Received - Process handle 1#{&1}")))]) # listener process spawning
    spawn(QueueServer, :subscribe, [queue_server, :log, QueueServer.create_handler(&(IO.puts("Log Received - Process handle 2#{&1}")))]) # listener process spawning
    spawn(QueueServer, :subscribe, [queue_server, :telemetry, QueueServer.create_handler(&(IO.puts("Telemetry - #{&1}")))]) # listener process spawning

    opts = [strategy: :one_for_one, name: WebServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
