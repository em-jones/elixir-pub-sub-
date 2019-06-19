defmodule Repo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Repo.Worker.start_link(arg)
      # {Repo.Worker, arg}
      worker(Mongo, [[name: :mongodb, database: 'feelz', pool_size: 2, user: 'admin', password: 'banesullivan']])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Repo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
