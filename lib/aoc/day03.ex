defmodule AoC.Day03 do
  @moduledoc false

  def part_1 do
    File.stream!("data/day03-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_input_line!/1)
    |> AoC.combinations(2)
    |> Enum.reduce(MapSet.new(), fn pair, acc -> MapSet.put(acc, intersect_rectangles(pair)) end)
    |> MapSet.delete(nil)
    |> Enum.reduce(MapSet.new(), &union_rectangle/2)
    |> MapSet.size
  end

  # def part_2 do
  #   File.stream!("data/day03-input.txt")
  # end

  def parse_input_line!(line) do
    Regex.named_captures(~r/\A#(?<id>\d+)\s*@\s*(?<left>\d+)\s*,\s*(?<top>\d+)\s*:\s*(?<width>\d+)\s*x\s*(?<height>\d+)\z/, line)
    |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, String.to_atom(k), String.to_integer(v)) end)
  end

  def intersect_rectangles(pair) do
    rect_1 = List.first(pair)
    rect_2 = List.last(pair)

    {left, width} = intersect_dimension(rect_1.left, (rect_1.left + rect_1.width), rect_2.left, (rect_2.left + rect_2.width))
    {top, height} = intersect_dimension(rect_1.top, (rect_1.top + rect_1.height), rect_2.top, (rect_2.top + rect_2.height))

    rect_from_coordinates(top, left, height, width)
  end

  def rect_from_coordinates(_, _, 0, _), do: nil
  def rect_from_coordinates(_, _, _, 0), do: nil
  def rect_from_coordinates(top, left, height, width), do: %{top: top, left: left, height: height, width: width}

  def intersect_dimension(seg_1_left, seg_1_right, seg_2_left, seg_2_right)
    when (seg_1_left <= seg_2_left) and (seg_1_right > seg_2_left) and (seg_1_right <= seg_2_right),
    do: {seg_2_left, seg_1_right - seg_2_left}
  def intersect_dimension(seg_1_left, seg_1_right, seg_2_left, seg_2_right)
    when (seg_1_left <= seg_2_left) and (seg_1_right > seg_2_right),
    do: {seg_2_left, seg_2_right - seg_2_left}
  def intersect_dimension(seg_1_left, seg_1_right, seg_2_left, seg_2_right)
    when (seg_1_left > seg_2_left) and (seg_1_left < seg_2_right) and (seg_1_right <= seg_2_right),
    do: {seg_1_left, seg_1_right - seg_1_left}
  def intersect_dimension(seg_1_left, seg_1_right, seg_2_left, seg_2_right)
    when (seg_1_left > seg_2_left) and (seg_1_left < seg_2_right) and (seg_1_right > seg_2_right),
    do: {seg_1_left, seg_2_right - seg_1_left}
  def intersect_dimension(_, _, _, _), do: {0, 0}

  def union_rectangle(nil, acc), do: acc
  def union_rectangle(rect, acc) do
    points_for_rect(rect)
    |> Enum.reduce(acc, fn point, acc -> MapSet.put(acc, point) end)
  end

  def points_for_rect(rect) do
    for x <- 0..(rect.width - 1), y <- 0..(rect.height - 1) do
      {(rect.left + x), (rect.top + y)}
    end
  end
end
