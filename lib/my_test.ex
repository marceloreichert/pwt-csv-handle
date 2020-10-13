defmodule MyTest do
  @moduledoc """
  Documentation for `MyTest`.
  """

  require Logger

  NimbleCSV.define(MyParser, separator: ",", escape: "\"")

  def handle_csv do
    url = "https://gist.githubusercontent.com/chronossc/1a010c6968528066acbee6bc03c2aefa/raw/bfbd1f86ed026c935e6b4df365caf0cd054ce947/cities.csv"

    {:ok, memory_pid} = Memory.start_link()

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body |> save_data(memory_pid)

        [h1,h2,h3|t] = get_data(memory_pid)

        %{state1: h1, state2: h2, state3: h3}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.warn("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.warn(reason)
    end
  end

  defp save_data(body, memory_pid) do
    body
    |> MyParser.parse_string
    |> Enum.map(fn [code, city_state] ->
        [head | tail] = String.split(city_state, "(")

        Memory.push(memory_pid, %{
              state: List.first(tail) |> String.replace_suffix(")", ""),
              city: head
            })
      end)
  end

  defp get_data(memory_pid) do
    [h1,h2,h3|t] =
      Memory.list(memory_pid)
      |> Enum.group_by(&(&1.state))
      |> Enum.map(fn {_id, data} ->
        %{state: _id, count: Enum.count(data)} end )
      |> Enum.sort(&(&1 >= &2))
  end
end
