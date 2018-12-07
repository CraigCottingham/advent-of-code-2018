defmodule AoC.Day05.Spec do
  @moduledoc false

  use ESpec

  describe "sanity checks" do
    before do: allow File |> to(accept(:stream!, fn(_, _, _) -> test_data() |> String.split(~r//) end))
    let :test_data, do: "dabAcCaCBAcCcaDA"

    it do
      expect(AoC.Day05.part_1()) |> to(eq(10))
      expect(AoC.Day05.part_2()) |> to(eq(0))
    end
  end
end
