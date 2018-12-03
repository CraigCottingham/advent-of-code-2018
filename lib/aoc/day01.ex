defmodule AoC.Day01 do
  @moduledoc false

  def part_1 do
    File.stream!("data/day01-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(0, fn delta, acc -> acc + delta end)
  end

  def part_2 do
    File.stream!("data/day01-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce([], fn delta, acc -> [acc, delta] end)
    |> List.flatten
    |> Stream.cycle
    |> Enum.reduce_while({0, MapSet.new([0])}, &calc_new_frequency/2)
    |> elem(0)
  end

  defp calc_new_frequency(delta, {acc, seen}) do
    new_acc = acc + delta
    if MapSet.member?(seen, new_acc) do
      {:halt, {new_acc, seen}}
    else
      {:cont, {new_acc, MapSet.put(seen, new_acc)}}
    end
  end
end
