defmodule Gpt3FirstFlightTest do
  use ExUnit.Case
  doctest GPT3FirstFlight

  # test "greets the world" do
  #   assert Gpt3FirstFlight.hello() == :world
  # end

  test "poll answer - invalid" do
    assert GPT3FirstFlight.ClassificationPoll.start("good") == {:ok, "good", "Invalid"}
  end

  test "poll answer - valid" do
    assert GPT3FirstFlight.ClassificationPoll.start(
             "The second logo B is clear. so i like the send logo."
           ) == {:ok, "The second logo B is clear. so i like the send logo.", "Valid"}
  end

  test "sentiment classification - positive" do
    assert GPT3FirstFlight.Classification.start("Thank you for your good work, Transport dept") ==
             {:ok, "Thank you for your good work, Transport dept", "Positive"}
  end

  test "sentiment classification - negative" do
    assert GPT3FirstFlight.Classification.start(
             "The municipality people haven't yet collected the garbage"
           ) == {:ok, "The municipality people haven't yet collected the garbage", "Negative"}
  end

  test "content filtering - safe" do
    assert GPT3FirstFlight.ContentFilter.start("It was great to meet an old friend yesterday") ==
             {:ok, "It was great to meet an old friend yesterday", "safe"}
  end

  test "content filtering - unsafe" do
    assert GPT3FirstFlight.ContentFilter.start("The code shit the bed") ==
             {:ok, "The code shit the bed", "unsafe"}
  end

  test "content filtering - sensitive" do
    assert GPT3FirstFlight.ContentFilter.start(
             "Donald Trump is probably the worst thing that happened to the US"
           ) ==
             {:ok, "Donald Trump is probably the worst thing that happened to the US",
              "sensitive"}
  end

  # test "completion" do
  #   assert GPT3FirstFlight.start("Hey, there!") == {:ok, _}
  # end
end
