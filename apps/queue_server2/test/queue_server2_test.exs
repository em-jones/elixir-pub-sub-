defmodule QueueServer2Test do
  use ExUnit.Case
  doctest QueueServer2

  test "greets the world" do
    assert QueueServer2.hello() == :world
  end
end
