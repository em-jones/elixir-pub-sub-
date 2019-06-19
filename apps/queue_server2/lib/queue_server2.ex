defmodule QueueServer2 do
  @moduledoc """
  Documentation for QueueServer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> QueueServer.hello()
      :world

  """
  require Logger

  defp get_queue(queue_name) do
    #    registered? = Enum.any?(Process.registered(), fn name -> name == queue_name end)
    #    unless registered? do
    #      with {:ok, queue} <- Store2.init(),
    #           true <- Process.register(queue, queue_name),
    #           do: Process.whereis(queue_name)
    #    else
    #      Process.whereis(queue_name)
    #    end
  end

  def subscribe(queue_name, handler) do
    #    Logger.info("Subscribing #{inspect(queue_name)}")
    #
    #    with queue <- get_queue(queue_name),
    #         #         do: spawn(fn -> Store.subscribe(queue, handler) end)
    #         do: Task.start_link(Store2, :subscribe, [queue, handler])
  end

  def publish(queue_name, message) do
    #    with queue <- get_queue(queue_name),
    #         #         do: spawn(fn -> Store.publish(queue, handler) end)
    #         do: Task.start_link(Store2, :publish, [queue, message])
  end
end
