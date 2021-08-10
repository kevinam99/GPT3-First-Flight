defmodule GPT3Test do
  @author Kevin
  @moduledoc """
  Module to test with GPT 3

  Here, we'll only test completions with the
  Davinci engine on OpenAI
  """

  defp api_key() do
    "<PASTE_YOUR_API_KEY_HERE>"
  end

  defp data() do
    prompt = %{
      # prompt is the input given to the engine.
      # multiple inputs can be fed with with sending each
      # input as a list element to `prompt`
      prompt: "This is a test",
      max_tokens: 5
    }

    {:ok, json} = Jason.encode(prompt)
    # Jason will encode the map into a compatible
    # json form
    json
  end

  defp headers() do
    [
      "Content-Type": "application/json",
      "Authorization": "Bearer #{api_key()}"
    ]
  end

  defp url() do
    "https://api.openai.com/v1/engines/davinci/completions"
  end

  def start() do
    HTTPoison.start()
    {:ok, response} = HTTPoison.post(url(), data(), headers())
    # IO.inspect(response)
    {:ok, body} = Jason.decode(response.body)
    response_map = body["choices"] |> List.first
    response_map["text"]
  end
end
