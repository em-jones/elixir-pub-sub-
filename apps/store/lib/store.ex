defmodule Store do
  @moduledoc """
  Documentation for Store.
  """

  @doc """
  Store creation -
  "spawns" (Task.start_link) a process to act as a pub/sub server
  ## Examples
      iex> {:ok, server} = Store.init

  """
  require Logger

  def init do
    {:ok, agent} = Agent.start_link(fn -> [] end)
    Task.start_link(__MODULE__, :run, [agent])
  end

  def subscribe(process, handler) do
    Logger.info("Subscribing in store")
    send(process, {:subscribe, self()})
    listen(handler)
  end

  def listen(handler) do
    receive do
      message ->
        handler.(message)
        listen(handler)
    end
  end

  def publish(server, message) do
    send(server, {:publish, message})
  end

  @doc """
  Store.run - defines our receiver that performs one of two actions before waiting for next message:
  publish - iterates over each subscriber's PID and sends it a message
  subscribe - adds a subscriber pid to the list of subscribers

  """
  def run(agent) do
    receive do
      {:publish, message} ->
        Agent.get(agent, fn subscribers -> Enum.each(subscribers, fn subscriber -> send(subscriber, message) end) end)
        run(agent)

      {:subscribe, subscriber} ->
        Agent.update(agent, fn subscribers -> [subscriber | subscribers] end)
        run(agent)
    end
  end

end
