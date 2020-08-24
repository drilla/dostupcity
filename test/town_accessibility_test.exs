defmodule TATest do
  use ExUnit.Case
  doctest Dostup

  test "greets the world" do
    assert Dostup.hello() == :world
  end
end
