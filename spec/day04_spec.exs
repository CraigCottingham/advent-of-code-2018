defmodule AoC.Day04.Spec do
  @moduledoc false

  use ESpec

  describe "parse_input_line!/1" do
    let :parsed, do: AoC.Day04.parse_input_line!(input())

    context "changeover message" do
      let :input, do: "[1518-11-22 00:00] Guard #1231 begins shift"

      it do
        expect(fn -> parsed() end) |> not_to(raise_exception())
        expect(is_tuple(parsed())) |> to(be_truthy())
        expect(elem(parsed(), 0)) |> to(eq(:changeover))
        expect(is_map(elem(parsed(), 1))) |> to(be_truthy())
      end
    end

    context "sleep message" do
      let :input, do: "[1518-04-13 00:00] falls asleep"

      it do
        expect(fn -> parsed() end) |> not_to(raise_exception())
        expect(is_tuple(parsed())) |> to(be_truthy())
        expect(elem(parsed(), 0)) |> to(eq(:down))
        expect(is_map(elem(parsed(), 1))) |> to(be_truthy())
      end
    end

    context "wake message" do
      let :input, do: "[1518-04-06 00:58] wakes up"

      it do
        expect(fn -> parsed() end) |> not_to(raise_exception())
        expect(is_tuple(parsed())) |> to(be_truthy())
        expect(elem(parsed(), 0)) |> to(eq(:up))
        expect(is_map(elem(parsed(), 1))) |> to(be_truthy())
      end
    end
  end

  describe "sanity checks" do
    before do: allow File |> to(accept(:stream!, fn(_) -> test_data() end))
    let :test_data do
      [
        "[1518-11-01 00:00] Guard #10 begins shift",
        "[1518-11-01 00:05] falls asleep",
        "[1518-11-01 00:25] wakes up",
        "[1518-11-01 00:30] falls asleep",
        "[1518-11-01 00:55] wakes up",
        "[1518-11-01 23:58] Guard #99 begins shift",
        "[1518-11-02 00:40] falls asleep",
        "[1518-11-02 00:50] wakes up",
        "[1518-11-03 00:05] Guard #10 begins shift",
        "[1518-11-03 00:24] falls asleep",
        "[1518-11-03 00:29] wakes up",
        "[1518-11-04 00:02] Guard #99 begins shift",
        "[1518-11-04 00:36] falls asleep",
        "[1518-11-04 00:46] wakes up",
        "[1518-11-05 00:03] Guard #99 begins shift",
        "[1518-11-05 00:45] falls asleep",
        "[1518-11-05 00:55] wakes up",
      ]
    end

    it do
      expect(AoC.Day04.part_1()) |> to(eq(240))
      expect(AoC.Day04.part_2()) |> to(eq(4455))
    end
  end
end
