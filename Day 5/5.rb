require 'aoc_utils'

def main
  # === Part 1 ===
=begin
  time_start = Time.now
  fresh_food_ranges, available_food_ids = AocUtils.read_two_parts('Day 5/input.txt', 'Integer', 'Integer')
  available_food_ids.flatten!
  fresh_food_ranges.map! { |range| [range[0], -range[1]] }
  available_food_ids.sort!
  fresh_food_ranges.sort!
  print zipish_count_a1_in_a2(available_food_ids, fresh_food_ranges)
  time_end = Time.now
  puts "\nExecution Time: #{(time_end - time_start) * 1000} ms"
=end

  # === Part 2 ===
  time_start = Time.now
  fresh_food_ranges, _ = AocUtils.read_two_parts('Day 5/input.txt', 'Integer', 'Integer')
  fresh_food_ranges.map! { |range| [range[0], -range[1]] }
  fresh_food_ranges.sort!
  fresh_food_ranges = clean_up_ranges(fresh_food_ranges)
  print fresh_food_ranges.reduce(0) { |sum, range| sum + (range[1] - range[0] + 1) }
  time_end = Time.now
  puts "\nExecution Time: #{(time_end - time_start) * 1000} ms"

end

# === Part 2 Helper ===
def clean_up_ranges(fresh_food_ranges)
  cleaned_ranges = []
  (0...fresh_food_ranges.length - 1).each do |i|
    current_range = fresh_food_ranges[i]
    next_range = fresh_food_ranges[i + 1]
    if current_range[1] < next_range[0]
      cleaned_ranges << current_range
      next
    end
    fresh_food_ranges[i + 1] = [current_range[0], [current_range[1], next_range[1]].max]
  end
  cleaned_ranges << fresh_food_ranges[-1]
  cleaned_ranges
end

# === Part 1 Helper ===
def zipish_count_a1_in_a2(arr1, arr2)
  count = 0
  index1 = 0
  index2 = 0
  while index1 < arr1.length && index2 < arr2.length
    available_id = arr1[index1]
    range_start = arr2[index2][0]
    range_end = arr2[index2][1]

    if available_id < range_start
      index1 += 1
    elsif available_id > range_end
      index2 += 1
    else
      count += 1
      index1 += 1
    end
  end
  count
end

main