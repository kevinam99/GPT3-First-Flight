defmodule Gpt3TestTest do
  use ExUnit.Case
  doctest Gpt3Test

  test "greets the world" do
    assert Gpt3Test.hello() == :world
  end
end
