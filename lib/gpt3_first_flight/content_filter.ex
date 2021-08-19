defmodule GPT3FirstFlight.ContentFilter do
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
      Authorization: "Bearer #{Application.fetch_env!(:gpt3_first_flight, :api_key)}"
    ]
  end

  defp url() do
    "https://api.openai.com/v1/engines/content-filter-alpha-c4/completions"
  end

  defp run_query(query) do
    HTTPoison.start()

    case HTTPoison.post(url(), data(query), headers()) do
      # if success, output the result
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        {:ok, body} = Jason.decode(response, keys: :atoms)

        case hd(body.choices).text do
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
  end

  # Now, I have added batch processing capability.
  # Give the input as a list of queries and it will generate the relevant output
  def start(queries \\ ["default query", "good"]) do
    Task.async_stream(
      queries,
      fn query ->
        run_query(query)
      end,
      max_concurrency: 5,
      timeout: 30_000,
      on_timeout: :exit
    )
    |> Enum.map(fn
      {:ok, result} -> result
      _ -> "Something went wrong"
    end)
  end
end
