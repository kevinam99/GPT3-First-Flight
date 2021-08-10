defmodule GPT3Test do
  require HTTPoison
  # import Jason
  @moduledoc """
  Module to test with GPT 3
  """

  @doc """
  Hello world.

  ## Examples

  iex> Gpt3Test.hello()
  :world

  """

  defp api_key() do
    ""
  end

  defp data() do
    """
    {"prompt": "This is a test", "max_tokens": 5}
    """
  end

  defp headers() do
    [
      "Content-Type": "application/json",
      Authorization: "Bearer #{api_key()}"
    ]
  end

  defp url() do
    "https://api.openai.com/v1/engines/davinci/completions"
  end

  def start() do
    HTTPoison.start()
    {:ok, response} = HTTPoison.post(url(), data(), headers())
    IO.inspect(response.body)
  end
end
