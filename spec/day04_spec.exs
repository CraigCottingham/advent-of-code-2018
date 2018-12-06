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
end
