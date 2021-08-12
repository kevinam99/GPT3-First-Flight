defmodule Gpt3FirstFlightTest do
  use ExUnit.Case
  doctest GptFirstFlight

  test "greets the world" do
    assert GptFirstFlight.hello() == :world
  end
end
