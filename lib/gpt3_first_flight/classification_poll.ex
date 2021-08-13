defmodule GPT3FirstFlight.ClassificationPoll do
  import Secrets

  @moduledoc """
  Implementing text classification using the Ada engine.
  Here, we do it for classifying poll/survey answers as
  valid or invalid

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
      labels: ["valid", "invalid"]
    }

    {:ok, json} = Jason.encode(request_body)
    # Jason will encode the map into a compatible
    # json form
    json
  end

  # can either write the examples manually in the code or put them
  # in a file and then read that file.

  defp headers() do
    [
      "Content-Type": "application/json",
      Authorization: "Bearer #{api_key()}"
    ]
  end

  defp parse(body) do
    line_matcher = ~r{(\r|\n|\r\n)}
    clean_matcher = ~r/\d+\.\s*[a-zA-z]/
    sno_matcher = ~r/\d+\.\s*/

    body
    |> String.split(line_matcher)
    |> Enum.filter(&(Regex.match?(clean_matcher, &1) == true))
    |> Enum.map(&Regex.replace(sno_matcher, &1, ""))
  end

  defp training_examples do
    # copy and paste (return) the output of the following
    # read_training_data()

    {:ok, data} = File.read("input_examples/poll.json")
    {:ok, examples} = Jason.decode(data)
    examples
  end

  defp url() do
    "https://api.openai.com/v1/classifications"
  end

  defp read_training_data do
    filename = "xb.md"

    case File.read(filename) do
      {:ok, body} ->
        body |> parse

      {:error, reason} ->
        IO.puts("Error: #{:file.format_error(reason)} for file #{filename}")
        {:error, reason}

      _ ->
        IO.puts("Enter a valid filename")
        {:error}
    end
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
  def start(queries \\ ["better than A", "good"]) do
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
