defmodule Store do
  @moduledoc """
  Documentation for Store.
  """

  @doc """
  Store creation -
  spawns a process to act as a pub/sub server
  ## Examples
      iex> {:ok, server} = Store.init

  """
  require Logger

  def init do
    Task.start_link(__MODULE__, :run, [[]])
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
  def run(subscribers) do
    receive do
      {:publish, message} ->
        Enum.each(subscribers, fn subscriber -> send(subscriber, message) end)
        run(subscribers)

      {:subscribe, subscriber} ->
        run([subscriber | subscribers])
    end
  end

  def hello(val \\ "world") do
    "Hello #{val}" |> IO.puts()
  end
end
