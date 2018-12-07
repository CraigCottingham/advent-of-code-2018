defmodule AoC.Day06.Spec do
  @moduledoc false

  use ESpec

  describe "sanity checks" do
    before do: allow File |> to(accept(:stream!, fn(_) -> test_data() end))
    let :test_data do
      [
        "1, 1",
        "1, 6",
        "8, 3",
        "3, 4",
        "5, 5",
        "8, 9",
      ]
    end

    it do
      expect(AoC.Day06.part_1()) |> to(eq(0))
      expect(AoC.Day06.part_2()) |> to(eq(0))
    end
  end
end
