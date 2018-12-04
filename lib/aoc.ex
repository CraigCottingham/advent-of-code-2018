defmodule AoC do
  @moduledoc false

  def combinations(_, 0), do: [[]]
  def combinations([], _), do: []
  def combinations([string1 | rest], m) do
    (for sublist <- combinations(rest, m - 1), do: [string1 | sublist]) ++ combinations(rest, m)
  end
end
