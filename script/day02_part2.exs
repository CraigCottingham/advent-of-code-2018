defmodule Day02.Part2 do
  @moduledoc false

  def run do
    File.stream!("data/day02-input.txt")
    |> Enum.map(&String.trim/1)
    |> combinations(2)
    |> Enum.map(fn pair -> calculate_difference(List.first(pair), List.last(pair)) end)
    |> Enum.map(fn {string1, string2, list} -> {string1, string2, Enum.filter(list, fn item -> elem(item, 0) != :eq end)} end)
    |> Enum.filter(fn {_, _, list} -> Enum.count(list) == 2 end)
    |> Enum.filter(&single_char_edit?/1)
    |> Enum.map(&common_characters/1)
    |> IO.puts
  end

  defp combinations(_, 0), do: [[]]
  defp combinations([], _), do: []
  defp combinations([string1 | rest], m) do
    (for sublist <- combinations(rest, m - 1), do: [string1 | sublist]) ++ combinations(rest, m)
  end

  defp calculate_difference(string1, string2) do
    {string1, string2, String.myers_difference(string1, string2)}
  end

  defp single_char_edit?({_, _, changes}) do
    ((Keyword.get(changes, :del, "") |> String.length) == 1) &&
    ((Keyword.get(changes, :ins, "") |> String.length) == 1)
  end

  defp common_characters({string1, string2, _}) do
    calculate_difference(string1, string2)
    |> elem(2)
    |> Enum.reduce("", &apply_change/2)
  end

  defp apply_change({:eq, str}, acc), do: acc <> str
  defp apply_change(_, acc), do: acc
end

Day02.Part2.run
