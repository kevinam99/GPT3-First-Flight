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
      labels: ["Positive", "Negative", "Neutral"],
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
      Authorization: "Bearer #{api_key()}"
    ]
  end

  defp url() do
    "https://api.openai.com/v1/engines/davinci/completions"
  end

  def start() do
    HTTPoison.start()

    case HTTPoison.post(url(), data(), headers()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} -> # if success, output the result
        {:ok, body} = Jason.decode(response)
        response_map = body["choices"] |> List.first()
        response_map["text"]

        {:ok, %HTTPoison.Response{status_code: 400, body: response}} -> # if failure, inspect error
          {:ok, error_msg} = Jason.decode(response)
          error_msg

        {:ok, %HTTPoison.Response{status_code: 404}} -> # if url not found
          "The URL #{url()} does not exist"
    end

    # IO.inspect(response)
  end
end
