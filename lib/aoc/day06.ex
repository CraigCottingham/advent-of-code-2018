defmodule AoC.Day06 do
  @moduledoc false

  def part_1 do
    File.stream!("data/day06-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_input_line!/1)

    |> calculate_part_1_answer()
  end

  def part_2 do
    File.stream!("data/day06-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_input_line!/1)

    |> calculate_part_2_answer()
  end

#  132, 308

  def parse_input_line!(line) do
    parsed_line = Regex.named_captures(~r/\A(?<x>\d+)\s*,\s*(?<y>\d+)\z/, line)
    {parsed_line["x"], parsed_line["y"]}
  end

  def calculate_part_1_answer(_), do: 0

  def calculate_part_2_answer(_), do: 0
end
