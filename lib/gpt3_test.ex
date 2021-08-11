defmodule GPT3Test do
  import Secrets
  @author Kevin
  @moduledoc """
  Module to test with GPT 3

  Here, we'll only test completions with the
  Davinci engine on OpenAI

  This is using a completion api. Give a sentence as input
  and GPT3 will complete the sentence for you
  """

  defp data() do
    request_body = %{
      # prompt is the input given to the engine.
      # multiple inputs can be fed with with sending each
      # input as a list element to `prompt`
      prompt: "This is a test",
      # total number of allowed tokens in the response from GPT3
      max_tokens: 5
    }

    {:ok, json} = Jason.encode(request_body)
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
      # if success, output the result
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        {:ok, body} = Jason.decode(response)
        response_map = body["choices"] |> List.first()
        {:ok, response_map["text"]}

      # if failure, inspect error
      {:ok, %HTTPoison.Response{status_code: 400, body: response}} ->
        {:ok, error_msg} = Jason.decode(response)
        {:error, error_msg}

      # if url not found
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "The URL #{url()} does not exist"}

      # Invalid auth header.
      {:ok, %HTTPoison.Response{status_code: 401, body: response}} ->
        {:error, "Something bad happened, #{response}"}
    end

    # IO.inspect(response)
  end
end
