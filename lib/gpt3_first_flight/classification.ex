defmodule GPT3FirstFlight.Classification do
  import Secrets

  @moduledoc """
  Implementing text classification using the Ada engine.
  The example shown here is what we used in t=our final year
  BE project.

  It understood the training examples well and it handles spelling mistakes.
  It also handles grmmatical errors.
  """

  # defp api_key() do
  #   "<PASTE_YOUR_API_KEY_HERE>"
  # end

  defp data(query) do
    request_body = %{
      # A list of examples with labels, in the follwing format:
      examples: training_examples(),
      # Query to be classified.
      query: query,
      # ID of the engine to use for Search. Deafault to Ada.
      search_model: "ada",
      model: "curie",
      labels: ["Positive", "Negative", "Neutral"]
    }

    {:ok, json} = Jason.encode(request_body)
    # Jason will encode the map into a compatible
    # json form
    json
  end

  # can either write the examples manually in the code or put them
  # in a file and then read that file.
  defp training_examples do
    [
      [
        "No Electricity in Mapusa since morning 9AM, kindly get it fixed ASAP, people are facing a lot of trouble.",
        "Negative"
      ],
      ["No water in GEC for last one week, kindly get it fixed!!", "Negative"],
      ["There was no electricity the entire night.
      Our transformer kept getting shorted at night, What kind of maintenance was done one week back,
      by cutting of the power supply of North Goa???", "Negative"],
      ["No light for 4 hours", "Negative"],
      ["I appreciate the department's work", "Positive"],
      ["Where can i apply from a new DDSSY scheme card??", "Neutral"],
      ["bad roads for 1 month(s)", "Negative"]
    ]
  end

  defp headers() do
    [
      "Content-Type": "application/json",
      Authorization: "Bearer #{api_key()}"
    ]
  end

  defp url() do
    "https://api.openai.com/v1/classifications"
  end

  defp run_query(query) do
    HTTPoison.start()

    case HTTPoison.post(url(), data(query), headers()) do
      # if success, output the result
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} ->
        {:ok, body} = Jason.decode(response)
        {:ok, query, body["label"]}

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

      {:error, %HTTPoison.Error{id: nil, reason: :timeout}} ->
        {:error, "The request timed out"}
    end
  end

  # Now, I have added batch processing capability.
  # Give the input as a list of queries and it will generate the relevant output
  def start(queries) do
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
