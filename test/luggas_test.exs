defmodule LuggasTest do
  use ExUnit.Case
  doctest Luggas

  test "greets the world" do
    assert Luggas.hello() == :world
  end
end
