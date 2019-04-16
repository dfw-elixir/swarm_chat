defmodule SwarmChatTest do
  use ExUnit.Case
  doctest SwarmChat

  test "greets the world" do
    assert SwarmChat.hello() == :world
  end
end
