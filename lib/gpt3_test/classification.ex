defmodule GPT3Test.Classification do
  @moduledoc """
  Implementing text classification using the Ada engine.
  The example shown here is what we used in t=our final year
  BE project.

  It understood the training examples well and it handles spelling mistakes.
  It also handles grmmatical errors.
  """
  defp api_key() do
    "<PASTE_YOUR_API_KEY_HERE>"
  end

  defp data(query) do
    request_body = %{
      examples: [
        ["No Electricity in Mapusa since morning 9AM, kindly get it fixed ASAP, people are facing a lot of trouble.", "Negative"],
        ["No water in GEC for last one week, kindly get it fixed!!", "Negative"],

        ["There was no electricity the entire night.
        Our transformer kept getting shorted at night, What kind of maintenance was done one week back,
        by cutting of the power supply of North Goa???", "Negative"],

        ["No light for 4 hours", "Negative"],
        ["I appreciate the department's work", "Positive"],
        ["bad roads for 1 month(s)", "Negative"]
        ],
      query: query,
      search_model: "ada",
      model: "curie",
      labels: ["Positive", "Negative", "Neutral"]
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
    "https://api.openai.com/v1/classifications"
  end

  def start(query) do
    HTTPoison.start()
    case HTTPoison.post(url(), data(query), headers()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} -> # if success, output the result
        {:ok, body} = Jason.decode(response)
        {:ok, query, body["label"]}

        {:ok, %HTTPoison.Response{status_code: 400, body: response}} -> # if failure, inspect error
          {:ok, error_msg} = Jason.decode(response)
          {:error, error_msg}

        {:ok, %HTTPoison.Response{status_code: 404}} -> # if url not found
          {:error, "The URL #{url()} does not exist"}

        {:ok, %HTTPoison.Response{status_code: 401, body: response}} -> # Invalid auth header.
          {:error, "Something bad happened, #{response}"}

        {:error, %HTTPoison.Error{id: nil, reason: :timeout}} ->
          {:error, "The request timed out"}
    end
  end
end
