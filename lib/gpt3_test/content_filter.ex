defmodule GPT3Test.ContentFilter do
  import Secrets
  @author Kevin
  @moduledoc """
  Module to test with GPT 3

  A filter to detect if given text contains unsafe or sensitive words.
  This needs a modification to the completion API.
  The filter classifies the input as - safe, sensitive or unsafe.
  This filter is not perfect and so, would have high probability of false positives.
  """

  defp data(query) do
    request_body = %{
      # prompt is the input given to the engine.
      # this form has to be maintained compulsorily
      prompt: "<|endoftext|>" <> query <> "\n--\nLabel:",
      # total number of allowed tokens in the response from GPT3
      max_tokens: 1,
      temperature: 0,
      top_p: 0,
      logprobs: 10
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
    "https://api.openai.com/v1/engines/content-filter-alpha-c4/completions"
  end

  def start(query \\ "default query") do
    HTTPoison.start()

    case HTTPoison.post(url(), data(query), headers()) do
      # if success, output the result
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        {:ok, body} = Jason.decode(response)
        response_map = body["choices"] |> List.first()

        case response_map["text"] do
          "0" -> {:ok, query, "safe"}
          "1" -> {:ok, query, "sensitive"}
          "2" -> {:ok, query, "unsafe"}
        end

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
