defmodule GPT3Test.Classification do
  defp api_key() do
    "<PASTE_YOUR_API_KEY_HERE>"
  end

  defp data do
    request_body = %{
      examples: [
        ["A happy moment", "Positive"],
        ["I am sad.", "Negative"],
        ["I am feeling awesome", "Positive"]],
      query: "It is a raining day :(",
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

  def start() do
    HTTPoison.start()
    case HTTPoison.post(url(), data(), headers()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response}} -> # if success, output the result
        {:ok, body} = Jason.decode(response)
        {:ok, body["label"]}

        {:ok, %HTTPoison.Response{status_code: 400, body: response}} -> # if failure, inspect error
          {:ok, error_msg} = Jason.decode(response)
          {:error, error_msg}

        {:ok, %HTTPoison.Response{status_code: 404}} -> # if url not found
          {:error, "The URL #{url()} does not exist"}

        {:ok, %HTTPoison.Response{status_code: 401, body: response}} -> # Invalid auth header.
          {:error, "Something bad happened, #{response}"}
    end
  end
end
