defmodule QueueServer do
  @moduledoc """
  The QueueServer module keeps a list of handlers mapped to a queue name
  to publish messages to
  """

  require Logger

  def start(queue_map \\ %{}) do
    spawn(QueueServer, :run, [queue_map])
  end

  @doc """
  The process that will manage the publishing of messages,
  and the subscribing of handlers
  """
  def run(queues) do
    new_queues =
      receive do
        message -> process(queues, message)
      end
    run(new_queues)
  end

  defp process(queues, {:publish, queue_name, message}) do
    list = Map.get(queues, queue_name, [])
    Enum.map(list, &(send(&1, {:message, message})))
    queues
  end

  defp process(queues, {:subscribe, queue_name, listener}) do
    Map.update(queues, queue_name, [listener], &([listener | &1])) # either create a new single-listener list, or update the list that already exists at this key
  end

  @doc """
  Our subscribe/3 module function takes a server, queue(name atom) and a handler and will send a message to
  the server we wish to subscribe to
  """
  def subscribe(server, queue, handler) do
    Logger.info("Subscribing #{inspect(queue)}")
    send(server, {:subscribe, queue, self()})
    subscription_listener(handler)
  end

  @doc """
  Our publish/3 module function receives a server, queue(name atom) and a message to pass to our queue by name
  """
  def publish(server, queue, message) do
    Logger.info("Sending message #{message} to queue: #{inspect(queue)}")
    send(server, {:publish, queue, message})
  end

  defp subscription_listener(handler) do
    receive do
      message ->
        handler.(message) # run logic that's waiting to run
        subscription_listener(handler) # start blocking again while waiting for next message
    end
  end

  @doc """
  Let's not make our clients know how they need to receive published messages
  """
  def create_handler(logic) do
    fn {:message, message} -> logic.(message) end
  end

end
