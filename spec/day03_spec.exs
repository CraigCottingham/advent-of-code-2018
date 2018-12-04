defmodule AoC.Day03.Spec do
  @moduledoc false

  use ESpec

  describe "parse_input_line!/1" do
    let :input, do: "#1 @ 1,3: 4x5"
    let :parsed, do: AoC.Day03.parse_input_line!(input())

    it do
      expect(fn -> parsed() end) |> not_to(raise_exception())
      expect(is_map(parsed())) |> to(be_truthy())
      expect(Map.has_key?(parsed(), :id)) |> to(be_truthy())
      expect(parsed().id) |> to(eq(1))
      expect(Map.has_key?(parsed(), :top)) |> to(be_truthy())
      expect(parsed().top) |> to(eq(1))
      expect(Map.has_key?(parsed(), :left)) |> to(be_truthy())
      expect(parsed().left) |> to(eq(3))
      expect(Map.has_key?(parsed(), :width)) |> to(be_truthy())
      expect(parsed().width) |> to(eq(4))
      expect(Map.has_key?(parsed(), :height)) |> to(be_truthy())
      expect(parsed().height) |> to(eq(5))
    end
  end

  describe "intersect_rectangles/1" do
    let :rect_1, do: AoC.Day03.parse_input_line!("#1 @ 1,2: 3x3")
    let :rect_2, do: AoC.Day03.parse_input_line!("#2 @ 2,1: 3x3")
    let :rect_3, do: AoC.Day03.parse_input_line!("#3 @ 3,3: 3x3")
    let :rect_4, do: AoC.Day03.parse_input_line!("#4 @ 7,8: 1x1")

    let :intersection_1_2, do: %{top: 2, left: 2, height: 2, width: 2}
    let :intersection_2_3, do: %{top: 3, left: 3, height: 2, width: 1}
    let :intersection_1_3, do: %{top: 3, left: 3, height: 1, width: 2}
    let :intersection_3_4, do: nil

    it do
      expect(AoC.Day03.intersect_rectangles([rect_1(), rect_2()])) |> to(eq(intersection_1_2()))
      expect(AoC.Day03.intersect_rectangles([rect_1(), rect_3()])) |> to(eq(intersection_1_3()))
      expect(AoC.Day03.intersect_rectangles([rect_2(), rect_3()])) |> to(eq(intersection_2_3()))
      expect(AoC.Day03.intersect_rectangles([rect_3(), rect_4()])) |> to(be_nil())
    end
  end

  describe "intersect_dimension/4" do
    it do
      expect(AoC.Day03.intersect_dimension(1, 2, 3, 5)) |> to(eq({0, 0}))
      expect(AoC.Day03.intersect_dimension(1, 3, 3, 5)) |> to(eq({0, 0}))
      expect(AoC.Day03.intersect_dimension(1, 4, 3, 5)) |> to(eq({3, 1}))
      expect(AoC.Day03.intersect_dimension(1, 5, 3, 5)) |> to(eq({3, 2}))
      expect(AoC.Day03.intersect_dimension(1, 6, 3, 5)) |> to(eq({3, 2}))
      expect(AoC.Day03.intersect_dimension(3, 4, 3, 5)) |> to(eq({3, 1}))
      expect(AoC.Day03.intersect_dimension(3, 5, 3, 5)) |> to(eq({3, 2}))
      expect(AoC.Day03.intersect_dimension(3, 6, 3, 5)) |> to(eq({3, 2}))
      expect(AoC.Day03.intersect_dimension(4, 5, 3, 5)) |> to(eq({4, 1}))
      expect(AoC.Day03.intersect_dimension(4, 6, 3, 5)) |> to(eq({4, 1}))
      expect(AoC.Day03.intersect_dimension(5, 6, 3, 5)) |> to(eq({0, 0}))
      expect(AoC.Day03.intersect_dimension(6, 7, 3, 5)) |> to(eq({0, 0}))
    end
  end

  describe "tests" do
    context "using data from the puzzle" do
      let :test_data, do: ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]

      it do
        expect(run_test_data(test_data())) |> to(eq(4))
      end
    end

    context "with three overlapping rectangles" do
      let :test_data, do: ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 4,4: 2x2"]

      it do
        expect(run_test_data(test_data())) |> to(eq(6))
      end
    end
  end

  defp run_test_data(data) do
    data
    |> Enum.map(&String.trim/1)
    |> Enum.map(&AoC.Day03.parse_input_line!/1)
    |> AoC.combinations(2)
    |> Enum.reduce(MapSet.new(), fn pair, acc -> MapSet.put(acc, AoC.Day03.intersect_rectangles(pair)) end)
    |> Enum.reduce(%{top: 0, left: 0, bottom: 0, right: 0, intersections: MapSet.new()}, &AoC.Day03.find_extremes/2)
    |> AoC.Day03.count_overlaps()
  end
end
