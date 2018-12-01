defmodule Day01 do
  @moduledoc false

  def run do
    File.stream!("data/day01-1-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(0, fn delta, acc -> acc + delta end)
    |> IO.puts
  end
end

Day01.run
