defmodule AoC.Day05 do
  @moduledoc false

  def part_1 do
    File.stream!("data/day05-input.txt", [], 1)
    |> Enum.reduce([], fn unit, acc -> [acc, unit] end)
    |> List.flatten()
    |> Enum.join()
    |> String.trim()

    |> react_units()

    |> calculate_part_1_answer()
  end

  def part_2 do
    File.stream!("data/day05-input.txt", [], 1)

    |> calculate_part_2_answer()
  end

  def react_units(polymer) do
    new_polymer = Enum.reduce(?A..?Z, polymer, fn unit, acc -> String.replace(acc, regex_for_unit(unit), "") end)
    if String.length(new_polymer) != String.length(polymer) do
      react_units(new_polymer)
    else
      new_polymer
    end
  end

  def regex_for_unit(?A), do: ~r/(?:Aa)|(?:aA)/
  def regex_for_unit(?B), do: ~r/(?:Bb)|(?:bB)/
  def regex_for_unit(?C), do: ~r/(?:Cc)|(?:cC)/
  def regex_for_unit(?D), do: ~r/(?:Dd)|(?:dD)/
  def regex_for_unit(?E), do: ~r/(?:Ee)|(?:eE)/
  def regex_for_unit(?F), do: ~r/(?:Ff)|(?:fF)/
  def regex_for_unit(?G), do: ~r/(?:Gg)|(?:gG)/
  def regex_for_unit(?H), do: ~r/(?:Hh)|(?:hH)/
  def regex_for_unit(?I), do: ~r/(?:Ii)|(?:iI)/
  def regex_for_unit(?J), do: ~r/(?:Jj)|(?:jJ)/
  def regex_for_unit(?K), do: ~r/(?:Kk)|(?:kK)/
  def regex_for_unit(?L), do: ~r/(?:Ll)|(?:lL)/
  def regex_for_unit(?M), do: ~r/(?:Mm)|(?:mM)/
  def regex_for_unit(?N), do: ~r/(?:Nn)|(?:nN)/
  def regex_for_unit(?O), do: ~r/(?:Oo)|(?:oO)/
  def regex_for_unit(?P), do: ~r/(?:Pp)|(?:pP)/
  def regex_for_unit(?Q), do: ~r/(?:Qq)|(?:qQ)/
  def regex_for_unit(?R), do: ~r/(?:Rr)|(?:rR)/
  def regex_for_unit(?S), do: ~r/(?:Ss)|(?:sS)/
  def regex_for_unit(?T), do: ~r/(?:Tt)|(?:tT)/
  def regex_for_unit(?U), do: ~r/(?:Uu)|(?:uU)/
  def regex_for_unit(?V), do: ~r/(?:Vv)|(?:vV)/
  def regex_for_unit(?W), do: ~r/(?:Ww)|(?:wW)/
  def regex_for_unit(?X), do: ~r/(?:Xx)|(?:xX)/
  def regex_for_unit(?Y), do: ~r/(?:Yy)|(?:yY)/
  def regex_for_unit(?Z), do: ~r/(?:Zz)|(?:zZ)/

  def calculate_part_1_answer(polymer), do: String.length(polymer)

  def calculate_part_2_answer(_), do: 0
end
