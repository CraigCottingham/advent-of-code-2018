defmodule AoC.Day04 do
  @moduledoc false

  def part_1 do
    File.stream!("data/day04-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.sort()
    |> Enum.map(&parse_input_line!/1)
    |> Enum.map(&adjust_date/1)
    |> Enum.map(&clean_events/1)
    |> Enum.chunk_while([], &chunk_by_date/2, &after_chunk_by_date/1)
    |> Enum.reject(fn chunk -> Enum.empty?(chunk) end)
    |> Enum.map(&List.flatten/1)
    |> Enum.map(&reduce_day_events/1)
    |> Enum.reduce(%{}, fn {day_data, _} = day, acc -> Map.update(acc, day_data.id, [day], fn list -> [list, day] end) end)
    |> Enum.reduce(%{}, fn {id, day_list}, acc -> Map.put(acc, id, List.flatten(day_list)) end)
    |> Enum.reduce(%{}, fn {id, day_list}, acc -> Map.put(acc, id, {day_list |> count_minutes(), day_list}) end)
    |> Enum.reject(fn {_id, day_list} -> elem(day_list, 0) == 0 end)
    |> Enum.reduce(%{}, fn {id, day_list}, acc -> Map.put(acc, id, convert_days_to_ranges({id, day_list}) |> elem(1)) end)
    |> Enum.max_by(fn {_id, {minutes, _day_list}} -> minutes end)
    |> strip_minutes()
    |> expand_ranges()
    |> find_max_minute()
    |> calculate_part_1_answer()
  end

  def part_2 do
    File.stream!("data/day04-input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.sort()
    |> Enum.map(&parse_input_line!/1)
    |> Enum.map(&adjust_date/1)
    |> Enum.map(&clean_events/1)
    |> Enum.chunk_while([], &chunk_by_date/2, &after_chunk_by_date/1)
    |> Enum.reject(fn chunk -> Enum.empty?(chunk) end)
    |> Enum.map(&List.flatten/1)
    |> Enum.map(&reduce_day_events/1)
    |> Enum.reduce(%{}, fn {day_data, _} = day, acc -> Map.update(acc, day_data.id, [day], fn list -> [list, day] end) end)
    |> Enum.reduce(%{}, fn {id, day_list}, acc -> Map.put(acc, id, List.flatten(day_list)) end)
    |> Enum.reduce(%{}, fn {id, day_list}, acc -> Map.put(acc, id, {day_list |> count_minutes(), day_list}) end)
    |> Enum.reject(fn {_id, day_list} -> elem(day_list, 0) == 0 end)
    |> Enum.reduce(%{}, fn {id, day_list}, acc -> Map.put(acc, id, convert_days_to_ranges({id, day_list}) |> elem(1)) end)
    |> Enum.reduce(%{}, fn {id, _} = item, acc -> Map.put(acc, id, strip_minutes(item) |> elem(1)) end)
    |> Enum.reduce(%{}, fn {id, _} = item, acc -> Map.put(acc, id, expand_ranges(item) |> elem(1)) end)
    |> Enum.reduce(%{}, &pivot_minute_map/2)
    |> Enum.reduce(%{}, &find_max_days_per_minute/2)
    |> Enum.max_by(fn {_minute, {_id, count}} -> count end)
    |> calculate_part_2_answer()
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
  def adjust_date({:changeover, %{day: day, hour: hour} = data}) when (hour > 0),
    do: adjust_date({:changeover, %{data | day: (day + 1), hour: 0}})

  # roll month forward
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 1) and (day > 31)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 2) and (day > 28)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 3) and (day > 31)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 4) and (day > 30)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 5) and (day > 31)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 6) and (day > 30)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 7) and (day > 31)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 8) and (day > 31)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 9) and (day > 30)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 10) and (day > 31)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 11) and (day > 30)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})
  def adjust_date({:changeover, %{month: month, day: day} = data}) when ((month == 12) and (day > 31)),
    do: adjust_date({:changeover, %{data | month: (month + 1), day: 1}})

  # roll year forward
  def adjust_date({:changeover, %{year: year, month: month} = data}) when (month > 12),
    do: adjust_date({:changeover, %{data | year: (year + 1), month: 1}})

  def adjust_date(event), do: event

  # strip unneeded keys from events
  def clean_events({:changeover, %{hour: _} = data}), do: clean_events({:changeover, data |> Map.delete(:hour) |> Map.delete(:minute)})
  def clean_events({:down, %{down: _} = data}), do: clean_events({:down, data |> Map.delete(:year) |> Map.delete(:month) |> Map.delete(:day) |> Map.delete(:down)})
  def clean_events({:up, %{up: _} = data}), do: clean_events({:up, data |> Map.delete(:year) |> Map.delete(:month) |> Map.delete(:day) |> Map.delete(:up)})

  def clean_events(event), do: event

  def chunk_by_date({:changeover, _} = data, acc), do: {:cont, acc, [data]}
  def chunk_by_date(data, acc), do: {:cont, [acc, data]}

  def after_chunk_by_date(acc), do: {:cont, acc, []}

  def reduce_day_events([{:changeover, day_data} | events]), do: reduce_day_events({day_data, []}, events)

  def reduce_day_events({day_data, event_list}, []), do: {day_data, event_list |> List.flatten}
  def reduce_day_events({day_data, event_list}, [{_, event_data} | events]), do: reduce_day_events({day_data, [event_list, event_data]}, events)

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

  def strip_minutes({id, {_, range_list}}), do: {id, range_list}

  def expand_ranges({id, range_list}), do: {id, Enum.reduce(range_list, %{}, &expand_range/2)}

  def expand_range(range, acc), do: Enum.reduce(range, acc, fn minute, acc2 -> Map.get_and_update(acc2, minute, &increment_minute/1) |> elem(1) end)

  def increment_minute(nil), do: {nil, 1}
  def increment_minute(value), do: {value, value + 1}

  def find_max_minute({id, minute_map}), do: {id, Enum.max_by(minute_map, fn {_, v} -> v end) |> elem(0)}

  def calculate_part_1_answer({id, minute}), do: (id * minute)

  def pivot_minute_map({id, minute_map}, acc) do
    Enum.reduce(minute_map, acc, fn {minute, count}, acc2 ->
                                   value = Map.get(acc2, minute, %{}) |> Map.put(id, count)
                                   Map.put(acc2, minute, value)
                                 end)
  end

  def find_max_days_per_minute({minute, guard_map}, acc) do
    Map.put(acc, minute, Enum.max_by(guard_map, fn {_id, count} -> count end))
  end

  def calculate_part_2_answer({minute, {id, _count}}), do: (id * minute)
end
