defmodule GPT3Test.Classification do
  defp api_key() do
    ""
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
  {:ok, response} = HTTPoison.post(url(), data(), headers())
  IO.inspect(response)
  # {:ok, body} = Jason.decode(response.body)
  # response_map = body["choices"] |> List.first
  # response_map["text"]
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
    {:ok, response} = HTTPoison.post(url(), data(), headers())
    IO.inspect(response)
    # {:ok, body} = Jason.decode(response.body)
    # response_map = body["choices"] |> List.first
    # response_map["text"]
  end
end
