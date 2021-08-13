defmodule Gpt3FirstFlightTest do
  use ExUnit.Case
  doctest GPT3FirstFlight

  # test "greets the world" do
  #   assert Gpt3FirstFlight.hello() == :world
  # end

  test "poll answer" do
    assert GPT3FirstFlight.ClassificationPoll.start([
             "good",
             "The second logo B is clear. so i like the send logo."
           ]) == [
             {:ok, "good", "Invalid"},
             {:ok, "The second logo B is clear. so i like the send logo.", "Valid"}
           ]
  end

  test "sentiment classification" do
    assert GPT3FirstFlight.Classification.start([
             "Thank you for your good work, Transport dept",
             "The municipality people haven't yet collected the garbage"
           ]) ==
             [
               {:ok, "Thank you for your good work, Transport dept", "Positive"},
               {:ok, "The municipality people haven't yet collected the garbage", "Negative"}
             ]
  end

  test "content filtering" do
    GPT3FirstFlight.ContentFilter.start([
      "Met a nice guy at the park",
      "The government is spying on us",
      "the code shit the bed"
    ]) ==
      [
        {:ok, "Met a nice guy at the park", "safe"},
        {:ok, "The government is spying on us", "sensitive"},
        {:ok, "the code shit the bed", "unsafe"}
      ]
  end

  # test "completion" do
  #   assert GPT3FirstFlight.start("Hey, there!") == {:ok, _}
  # end
end
