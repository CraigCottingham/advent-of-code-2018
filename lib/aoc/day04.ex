defmodule AoC.Day04 do
  @moduledoc false

  def part_1 do
    File.stream!("data/day04-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.sort()
    |> Enum.map(&parse_input_line!/1)
    |> Enum.map(&massage_event/1)
    |> Enum.chunk_while([], &chunk_by_date/2, &after_chunk_by_date/1)
    |> Enum.reject(fn chunk -> Enum.empty?(chunk) end)
    |> Enum.map(&List.flatten/1)
    |> Enum.map(&massage_day/1)
    |> Enum.reduce(%{}, fn {day_data, _} = day, acc -> Map.update(acc, day_data.id, [day], fn list -> [list, day] end) end)
    |> Enum.reduce(%{}, fn {id, day_list}, acc -> Map.put(acc, id, {day_list |> List.flatten() |> count_minutes(), day_list |> List.flatten()}) end)
    |> Enum.max_by(fn {_id, {minutes, _day_list}} -> minutes end)
    |> convert_days_to_ranges()
    |> expand_ranges()
    |> find_max_minute()
    |> calculate_part_1_answer()
  end

  def part_2 do
    # File.stream!("data/day04-input.txt")
    # |> Enum.map(&String.trim/1)
    # |> Enum.sort()
    # |> Enum.map(&parse_input_line!/1)

    0
  end

  def parse_input_line!(line) do
    Enum.flat_map([regex_changeover(), regex_sleep(), regex_wake()], fn regex ->
      case Regex.named_captures(regex, line) do
        %{"id" => _} = captures ->
          [{:changeover, AoC.atomify_keys(captures, fn value -> String.to_integer(value) end)}]
        %{"down" => _} = captures ->
          [{:down, AoC.atomify_keys(captures, fn value -> try do
                                                            String.to_integer(value)
                                                          rescue ArgumentError -> value
                                                          end
                                              end)}]
        %{"up" => _} = captures ->
          [{:up, AoC.atomify_keys(captures, fn value -> try do
                                                          String.to_integer(value)
                                                        rescue ArgumentError -> value
                                                        end
                                            end)}]
        _ -> []
      end
    end)
    |> List.first
  end

  def regex_changeover(), do: ~r/\A\[(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})\s+(?<hour>\d{2}):(?<minute>\d{2})\]\s+Guard\s+#(?<id>\d+)\s+begins\s+shift\b/
  def regex_sleep(), do: ~r/\A\[(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})\s+(?<hour>\d{2}):(?<minute>\d{2})\]\s+(?<down>falls\s+asleep)\b/
  def regex_wake(), do: ~r/\A\[(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})\s+(?<hour>\d{2}):(?<minute>\d{2})\]\s+(?<up>wakes\s+up)\b/

  # roll day forward
  def massage_event({:changeover, %{day: day, hour: hour} = data}) when (hour > 0),
    do: massage_event({:changeover, %{data | day: (day + 1), hour: 0}})

  # roll month forward
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 1) and (day > 31)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 2) and (day > 28)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 3) and (day > 31)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 4) and (day > 30)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 5) and (day > 31)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 6) and (day > 30)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 7) and (day > 31)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 8) and (day > 31)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 9) and (day > 30)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 10) and (day > 31)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 11) and (day > 30)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})
  def massage_event({:changeover, %{month: month, day: day} = data}) when ((month == 12) and (day > 31)),
    do: massage_event({:changeover, %{data | month: (month + 1), day: 1}})

  # roll year forward
  def massage_event({:changeover, %{year: year, month: month} = data}) when (month > 12),
    do: massage_event({:changeover, %{data | year: (year + 1), month: 1}})

  # strip unneeded keys from events
  def massage_event({:changeover, %{hour: _} = data}), do: massage_event({:changeover, data |> Map.delete(:hour) |> Map.delete(:minute)})
  def massage_event({:down, %{down: _} = data}), do: massage_event({:down, data |> Map.delete(:year) |> Map.delete(:month) |> Map.delete(:day) |> Map.delete(:down)})
  def massage_event({:up, %{up: _} = data}), do: massage_event({:up, data |> Map.delete(:year) |> Map.delete(:month) |> Map.delete(:day) |> Map.delete(:up)})

  def massage_event(event), do: event

  def chunk_by_date({:changeover, _} = data, acc), do: {:cont, acc, [data]}
  def chunk_by_date(data, acc), do: {:cont, [acc, data]}

  def after_chunk_by_date(acc), do: {:cont, acc, []}

  def massage_day([{:changeover, day_data} | events]), do: massage_day({day_data, []}, events)

  def massage_day({day_data, event_list}, []), do: {day_data, event_list |> List.flatten}
  def massage_day({day_data, event_list}, [{_, event_data} | events]), do: massage_day({day_data, [event_list, event_data]}, events)

  def count_minutes(day_list), do: Enum.reduce(day_list, 0, &count_minutes/2)

  def count_minutes({_, event_list}, acc) when is_list(event_list), do: count_minutes(event_list, acc)

  def count_minutes([], acc), do: acc
  def count_minutes([down_event | rest], acc), do: count_minutes(down_event, rest, acc)

  def count_minutes(down_event, [up_event | rest], acc), do: count_minutes(rest, (acc + count_interval(down_event, up_event)))

  def count_interval(down, up) when is_map(down) and is_map(up), do: ((up.hour * 60) + up.minute) - ((down.hour * 60) + down.minute)

  def convert_days_to_ranges({id, {minutes, day_list}}), do: {id, {minutes, Enum.map(day_list, &convert_events_to_range/1) |> List.flatten()}}

  def convert_events_to_range(day) when is_tuple(day), do: convert_events_to_range(elem(day, 1), [])
  def convert_events_to_range([], acc), do: List.flatten(acc)
  def convert_events_to_range([event_start | rest], acc), do: convert_events_to_range(event_start, rest, acc)
  def convert_events_to_range(event_start, [event_end | rest], acc), do: convert_events_to_range(rest, [acc, (time_to_minutes(event_start)..(time_to_minutes(event_end) - 1))])

  def time_to_minutes(%{hour: hour, minute: minute}), do: (hour * 60) + minute

  def expand_ranges({id, {minutes, ranges}}), do: {id, {minutes, Enum.reduce(ranges, %{}, &expand_range/2)}}

  def expand_range(range, acc), do: Enum.reduce(range, acc, fn minute, acc2 -> Map.get_and_update(acc2, minute, &increment_minute/1) |> elem(1) end)

  def increment_minute(nil), do: {nil, 1}
  def increment_minute(value), do: {value, value + 1}

  def find_max_minute({id, {_, minute_map}}), do: {id, Enum.max_by(minute_map, fn {_, v} -> v end) |> elem(0)}

  def calculate_part_1_answer({id, minute}), do: (id * minute)
end
