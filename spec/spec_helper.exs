ESpec.configure fn(config) ->
  config.before fn(tags) ->
    {:shared, solutions: AoC.SpecHelper.load_solutions(), tags: tags}
  end

  config.finally fn(_shared) ->
    :ok
  end
end

defmodule AoC.SpecHelper do
  @moduledoc false

  def load_solutions do
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
