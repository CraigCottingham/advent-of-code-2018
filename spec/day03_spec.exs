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
      expect(parsed().top) |> to(eq(3))
      expect(Map.has_key?(parsed(), :left)) |> to(be_truthy())
      expect(parsed().left) |> to(eq(1))
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
    let :intersection_2_3, do: %{top: 3, left: 3, height: 1, width: 2}
    let :intersection_1_3, do: %{top: 3, left: 3, height: 2, width: 1}
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
      expect(AoC.Day03.intersect_dimension(1, 4, 9, 25)) |> to(eq({0, 0}))
      expect(AoC.Day03.intersect_dimension(1, 9, 9, 25)) |> to(eq({0, 0}))
      expect(AoC.Day03.intersect_dimension(1, 16, 9, 25)) |> to(eq({9, 7}))
      expect(AoC.Day03.intersect_dimension(1, 25, 9, 25)) |> to(eq({9, 16}))
      expect(AoC.Day03.intersect_dimension(1, 36, 9, 25)) |> to(eq({9, 16}))
      expect(AoC.Day03.intersect_dimension(9, 16, 9, 25)) |> to(eq({9, 7}))
      expect(AoC.Day03.intersect_dimension(9, 25, 9, 25)) |> to(eq({9, 16}))
      expect(AoC.Day03.intersect_dimension(9, 36, 9, 25)) |> to(eq({9, 16}))
      expect(AoC.Day03.intersect_dimension(16, 25, 9, 25)) |> to(eq({16, 9}))
      expect(AoC.Day03.intersect_dimension(16, 36, 9, 25)) |> to(eq({16, 9}))
      expect(AoC.Day03.intersect_dimension(25, 36, 9, 25)) |> to(eq({0, 0}))
      expect(AoC.Day03.intersect_dimension(36, 49, 9, 25)) |> to(eq({0, 0}))
    end
  end

  describe "union_rectangle/2" do
    let :test_data, do: ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]
    let :union do
      test_data()
      |> Enum.map(&String.trim/1)
      |> Enum.map(&AoC.Day03.parse_input_line!/1)
      |> Enum.reduce(MapSet.new(), &AoC.Day03.union_rectangle/2)
    end

    it do
      expect(MapSet.size(union())) |> to(eq(32))
    end
  end

  describe "points_for_rect/1" do
    let :rect, do: %{top: 1, left: 2, height: 3, width: 4}
    let :points, do: AoC.Day03.points_for_rect(rect())

    it do
      expect(points()) |> to_not(be_nil())
      expect(Enum.count(points())) |> to(eq(12))

      expect(Enum.count(points(), fn point -> elem(point, 0) == rect().left end)) |> to(eq(3))
      expect(Enum.count(points(), fn point -> elem(point, 0) == (rect().left + 1) end)) |> to(eq(3))
      expect(Enum.count(points(), fn point -> elem(point, 0) == (rect().left + 2) end)) |> to(eq(3))
      expect(Enum.count(points(), fn point -> elem(point, 0) == (rect().left + 3) end)) |> to(eq(3))

      expect(Enum.count(points(), fn point -> elem(point, 1) == rect().top end)) |> to(eq(4))
      expect(Enum.count(points(), fn point -> elem(point, 1) == (rect().top + 1) end)) |> to(eq(4))
      expect(Enum.count(points(), fn point -> elem(point, 1) == (rect().top + 2) end)) |> to(eq(4))
    end
  end

  describe "sanity checks" do
    before do: allow File |> to(accept(:stream!, fn(_) -> test_data() end))

    context "using data from the puzzle" do
      let :test_data, do: ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]

      it do
        expect(AoC.Day03.part_1()) |> to(eq(4))
      end
    end

    context "with three overlapping rectangles" do
      let :test_data, do: ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 4,4: 2x2"]

      it do
        expect(AoC.Day03.part_1()) |> to(eq(6))
      end
    end

    context "with four coincident rectangles" do
      let :test_data, do: ["#1 @ 5,5: 2x2", "#2 @ 5,5: 2x2", "#3 @ 5,5: 2x2", "#4 @ 5,5: 2x2"]

      it do
        expect(AoC.Day03.part_1()) |> to(eq(4))
      end
    end
  end
end
