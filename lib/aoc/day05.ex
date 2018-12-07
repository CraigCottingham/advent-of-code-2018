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
    |> Enum.reduce([], fn unit, acc -> [acc, unit] end)
    |> List.flatten()
    |> Enum.join()
    |> String.trim()

    |> react_minus_one()
    |> Enum.min_by(&String.length/1)

    |> calculate_part_2_answer()
  end

  def react_units(polymer) do
    new_polymer = Enum.reduce(?A..?Z, polymer, fn unit, acc -> String.replace(acc, reaction_regex_for_unit(unit), "") end)
    if String.length(new_polymer) != String.length(polymer) do
      react_units(new_polymer)
    else
      new_polymer
    end
  end

  def reaction_regex_for_unit(?A), do: ~r/(?:Aa)|(?:aA)/
  def reaction_regex_for_unit(?B), do: ~r/(?:Bb)|(?:bB)/
  def reaction_regex_for_unit(?C), do: ~r/(?:Cc)|(?:cC)/
  def reaction_regex_for_unit(?D), do: ~r/(?:Dd)|(?:dD)/
  def reaction_regex_for_unit(?E), do: ~r/(?:Ee)|(?:eE)/
  def reaction_regex_for_unit(?F), do: ~r/(?:Ff)|(?:fF)/
  def reaction_regex_for_unit(?G), do: ~r/(?:Gg)|(?:gG)/
  def reaction_regex_for_unit(?H), do: ~r/(?:Hh)|(?:hH)/
  def reaction_regex_for_unit(?I), do: ~r/(?:Ii)|(?:iI)/
  def reaction_regex_for_unit(?J), do: ~r/(?:Jj)|(?:jJ)/
  def reaction_regex_for_unit(?K), do: ~r/(?:Kk)|(?:kK)/
  def reaction_regex_for_unit(?L), do: ~r/(?:Ll)|(?:lL)/
  def reaction_regex_for_unit(?M), do: ~r/(?:Mm)|(?:mM)/
  def reaction_regex_for_unit(?N), do: ~r/(?:Nn)|(?:nN)/
  def reaction_regex_for_unit(?O), do: ~r/(?:Oo)|(?:oO)/
  def reaction_regex_for_unit(?P), do: ~r/(?:Pp)|(?:pP)/
  def reaction_regex_for_unit(?Q), do: ~r/(?:Qq)|(?:qQ)/
  def reaction_regex_for_unit(?R), do: ~r/(?:Rr)|(?:rR)/
  def reaction_regex_for_unit(?S), do: ~r/(?:Ss)|(?:sS)/
  def reaction_regex_for_unit(?T), do: ~r/(?:Tt)|(?:tT)/
  def reaction_regex_for_unit(?U), do: ~r/(?:Uu)|(?:uU)/
  def reaction_regex_for_unit(?V), do: ~r/(?:Vv)|(?:vV)/
  def reaction_regex_for_unit(?W), do: ~r/(?:Ww)|(?:wW)/
  def reaction_regex_for_unit(?X), do: ~r/(?:Xx)|(?:xX)/
  def reaction_regex_for_unit(?Y), do: ~r/(?:Yy)|(?:yY)/
  def reaction_regex_for_unit(?Z), do: ~r/(?:Zz)|(?:zZ)/

  def calculate_part_1_answer(polymer), do: String.length(polymer)

  def react_minus_one(polymer) do
    Enum.map(?A..?Z, fn unit -> String.replace(polymer, remove_regex_for_unit(unit), "") end)
    |> Enum.map(&react_units/1)
  end

  def remove_regex_for_unit(?A), do: ~r/A/i
  def remove_regex_for_unit(?B), do: ~r/B/i
  def remove_regex_for_unit(?C), do: ~r/C/i
  def remove_regex_for_unit(?D), do: ~r/D/i
  def remove_regex_for_unit(?E), do: ~r/E/i
  def remove_regex_for_unit(?F), do: ~r/F/i
  def remove_regex_for_unit(?G), do: ~r/G/i
  def remove_regex_for_unit(?H), do: ~r/H/i
  def remove_regex_for_unit(?I), do: ~r/I/i
  def remove_regex_for_unit(?J), do: ~r/J/i
  def remove_regex_for_unit(?K), do: ~r/K/i
  def remove_regex_for_unit(?L), do: ~r/L/i
  def remove_regex_for_unit(?M), do: ~r/M/i
  def remove_regex_for_unit(?N), do: ~r/N/i
  def remove_regex_for_unit(?O), do: ~r/O/i
  def remove_regex_for_unit(?P), do: ~r/P/i
  def remove_regex_for_unit(?Q), do: ~r/Q/i
  def remove_regex_for_unit(?R), do: ~r/R/i
  def remove_regex_for_unit(?S), do: ~r/S/i
  def remove_regex_for_unit(?T), do: ~r/T/i
  def remove_regex_for_unit(?U), do: ~r/U/i
  def remove_regex_for_unit(?V), do: ~r/V/i
  def remove_regex_for_unit(?W), do: ~r/W/i
  def remove_regex_for_unit(?X), do: ~r/X/i
  def remove_regex_for_unit(?Y), do: ~r/Y/i
  def remove_regex_for_unit(?Z), do: ~r/Z/i

  def calculate_part_2_answer(polymer), do: String.length(polymer)
end
