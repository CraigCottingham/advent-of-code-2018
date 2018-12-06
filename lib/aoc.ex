defmodule AoC do
  @moduledoc false

  def atomify_keys(map, transform_values \\ fn value -> value end),
    do: Enum.reduce(map, %{}, fn {k, v}, acc -> Map.put(acc, String.to_atom(k), transform_values.(v)) end)

  def combinations(_, 0), do: [[]]
  def combinations([], _), do: []
  def combinations([string1 | rest], m),
    do: (for sublist <- combinations(rest, m - 1), do: [string1 | sublist]) ++ combinations(rest, m)
end
