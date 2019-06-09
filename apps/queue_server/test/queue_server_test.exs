defmodule QueueServerTest do
  use ExUnit.Case
  doctest QueueServer

  test "greets the world" do
    assert QueueServer.hello() == :world
  end
end
