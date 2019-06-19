defmodule QueueServer do
  @moduledoc """
  Documentation for QueueServer.
  """

  require Logger

  @doc """
  With our store's implementation of 'subscribe/2' what we're doing is spawning a new process that will act as our subscriber
  and that process has a handler attached to it and a queue process that we anticipate being published to, by
  """

  def subscribe(queue, handler) do
    Logger.info("Subscribing #{inspect(queue)}")
    registered? = Process.whereis(queue)
    unless registered? do
      Process.register(Store.init(), queue)
    end
    spawn(fn -> Store.subscribe(queue, handler) end)
    #         do: Task.start_link(Store, :subscribe, [queue, handler])
  end

  def publish(queue, message) do
    registered? = Process.whereis(queue)
    unless registered? do
      Process.register(Store.init(), queue)
    end
    spawn(fn -> Store.publish(queue, message) end)
    #         do: Task.start_link(Store, :publish, [queue, message])
  end
end
