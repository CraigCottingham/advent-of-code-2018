defmodule Day02.Part1 do
  @moduledoc false

  def run do
    File.stream!("data/day02-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn string -> {string, count_characters(string, %{})} end)
    |> Enum.reduce(%{2 => 0, 3 => 0}, &count_twos_and_threes/2)
    |> Map.values
    |> Enum.reduce(1, &(&1 * &2))
    |> IO.puts
  end

  defp count_characters(string, acc) do
    string
    |> String.split("", trim: true)
    |> Enum.reduce(acc, fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end

  defp count_twos_and_threes({_, char_counts}, acc) do
    acc = if Map.values(char_counts) |> Enum.member?(2) do
            Map.update(acc, 2, 1, &(&1 + 1))
          else
            acc
          end
    acc = if Map.values(char_counts) |> Enum.member?(3) do
            Map.update(acc, 3, 1, &(&1 + 1))
          else
            acc
          end
    acc
  end
end

Day02.Part1.run
