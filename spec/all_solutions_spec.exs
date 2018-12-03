defmodule AllSolutions.Spec do
  @moduledoc false

  use ESpec

  before do
    solutions = load_solutions()
    {:shared, solutions: solutions}
  end

  example_group "day 01" do
    it "part 1", do: expect(AoC.Day01.part_1()) |> to(eq(shared.solutions |> Map.fetch!("day_01") |> List.first))
    it "part 2", do: expect(AoC.Day01.part_2()) |> to(eq(shared.solutions |> Map.fetch!("day_01") |> List.last))
  end

  example_group "day 02" do
    it "part 1", do: expect(AoC.Day02.part_1()) |> to(eq(shared.solutions |> Map.fetch!("day_02") |> List.first))
    it "part 2", do: expect(AoC.Day02.part_2()) |> to(eq(shared.solutions |> Map.fetch!("day_02") |> List.last))
  end

  ##
  ##
  ##

  defp load_solutions do
    :yamerl_constr.file("solutions.yml")
    |> List.first
    |> Enum.into(%{})
    |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, to_string(k), convert_values(v)) end)
  end

  defp convert_values(values) when is_list(values), do: Enum.map(values, &convert_value/1)
  defp convert_values(values), do: values

  defp convert_value(v) when is_list(v), do: to_string(v)
  defp convert_value(v), do: v
end
