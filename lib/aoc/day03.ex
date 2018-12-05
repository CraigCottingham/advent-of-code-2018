defmodule AoC.Day03 do
  @moduledoc false

  def part_1 do
    File.stream!("data/day03-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_input_line!/1)
    |> AoC.combinations(2)
    |> Enum.reduce(MapSet.new(), fn pair, acc -> MapSet.put(acc, intersect_rectangles(pair)) end)
    |> Enum.reduce(%{top: 0, left: 0, bottom: 0, right: 0, intersections: MapSet.new()}, &find_extremes/2)
    |> count_overlaps()
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

    if (width == 0) || (height == 0) do
      nil
    else
      %{top: top, left: left, height: height, width: width}
    end
  end

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

  def find_extremes(nil, state), do: state
  def find_extremes(intersection, state) do
    state = if intersection.top < state.top do
              %{state | top: intersection.top}
            else
              state
            end
    state = if intersection.left < state.left do
              %{state | left: intersection.left}
            else
              state
            end
    state = if (intersection.top + intersection.height) > state.bottom do
              %{state | bottom: intersection.top + intersection.height}
            else
              state
            end
    state = if (intersection.left + intersection.width) > state.right do
              %{state | right: intersection.left + intersection.width}
            else
              state
            end
    %{state | intersections: MapSet.put(state.intersections, intersection)}
  end

  def count_overlaps(%{top: top, left: left} = state) do
    count_overlaps(state, top, left, 0)
  end

  def count_overlaps(%{bottom: bottom, right: right, intersections: intersections} = state, x, y, count) do
    count = count + overlaps_at(intersections, x, y)
    {x, y} = if (x + 1) == right do
               {state.left, y + 1}
             else
               {x + 1, y}
             end
    if y == bottom do
      count
    else
      count_overlaps(state, x, y, count)
    end
  end

  def overlaps_at(intersections, x, y) do
    if Enum.any?(intersections,
                 fn intersection ->
                   (y >= intersection.top) &&
                   (x >= intersection.left) &&
                   (y < (intersection.top + intersection.height)) &&
                   (x < (intersection.left + intersection.width))
                 end) do
      # IO.puts "#{x},#{y}"
      1
    else
      0
    end
  end
end
