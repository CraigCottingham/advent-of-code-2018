defmodule AoC.Day05 do
  @moduledoc false

  def part_1 do
    File.stream!("data/day05-input.txt", [], 1)

    |> calculate_part_1_answer()
  end

  def part_2 do
    File.stream!("data/day05-input.txt", [], 1)

    |> calculate_part_2_answer()
  end

  def calculate_part_1_answer(_), do: 0

  def calculate_part_2_answer(_), do: 0
end
