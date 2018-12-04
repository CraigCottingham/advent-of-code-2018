defmodule AoC.Day02 do
  @moduledoc false

  def part_1 do
    File.stream!("data/day02-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn string -> {string, count_characters(string, %{})} end)
    |> Enum.reduce(%{2 => 0, 3 => 0}, &count_twos_and_threes/2)
    |> Map.values
    |> Enum.reduce(1, &(&1 * &2))
  end

  def part_2 do
    File.stream!("data/day02-input.txt")
    |> Enum.map(&String.trim/1)
    |> AoC.combinations(2)
    |> Enum.map(fn pair -> calculate_difference(List.first(pair), List.last(pair)) end)
    |> Enum.map(fn {string1, string2, list} -> {string1, string2, Enum.filter(list, fn item -> elem(item, 0) != :eq end)} end)
    |> Enum.filter(fn {_, _, list} -> Enum.count(list) == 2 end)
    |> Enum.filter(&single_char_edit?/1)
    |> Enum.map(&common_characters/1)
    |> List.first
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
