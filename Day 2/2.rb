require 'aoc_utils'

@facts_dict = {2 => [1], 3 => [1], 4 => [2], 5 => [5], 6 => [3,2], 7 => [1], 8 => [4], 9 => [3], 10 => [5,2], 11 => [1], 12 => [6]}

def main
  ranges_strings = AocUtils.read_strings('Day 2/input.txt').flatten
  ranges = ranges_strings.map { |range_string| range_string_to_array(range_string) }
  ranges = ranges.reduce([]) do |acc, range|
    acc + split_range_into_ranges_with_same_digit_count(range)
  end
  #ranges = ranges.map { |range| omit_not_even_digit_numbers(range) }
  #sum = ranges.reduce(0) { |acc, range| acc + find_all_invalid_ids_part1(range).sum }
  sum = ranges.reduce(0) { |acc, range| acc + find_all_invalid_ids_part2(range).sum }
  print sum
end

# === Part 2 ===

def find_all_invalid_ids_part2(range)
  digit_count = range[0].to_s.length
  if digit_count < 2
    return []
  end
  if digit_count > 12
    raise "not implemented for digit counts greater than 12"
  end
  facts = @facts_dict[digit_count]
  invalid_ids = []
  (0..(facts.length - 1)).each do |i|
    first_x = facts[i]
    left_side_min = range[0].to_s[0, first_x].to_i
    left_side_max = range[1].to_s[0, first_x].to_i
    (left_side_min..left_side_max).each do |left_side|
      left_side_string = left_side.to_s
      invalid_id = (left_side_string * (digit_count/first_x)).to_i
      invalid_ids << invalid_id if invalid_id >= range[0] && invalid_id <= range[1]
    end
  end
  invalid_ids.uniq
end

def split_range_into_ranges_with_same_digit_count(range)
  min_length = range[0].to_s.length
  max_length = range[1].to_s.length
  if min_length == max_length
    return [range]
  end
  if (range[0].to_s.length - range[1].to_s.length).abs > 1
    raise "not implemented for ranges with more than 1 digit count difference"
  end
  result = []
  first_range_end = (10**min_length) - 1
  second_range_start = 10**min_length
  result << [range[0], first_range_end]
  result << [second_range_start, range[1]]
  result
end

# === Part 1 ===

def find_all_invalid_ids_part1(range)
  left_side_min = range[0].to_s[0, range[0].to_s.length / 2].to_i
  left_side_max = range[1].to_s[0, range[1].to_s.length / 2].to_i
  invalid_ids = []
  (left_side_min..left_side_max).each do |left_side|
    left_side_string = left_side.to_s
    invalid_id = (left_side_string + left_side_string).to_i
    invalid_ids << invalid_id if invalid_id >= range[0] && invalid_id <= range[1]
  end
  invalid_ids
end

def range_string_to_array(range_string)
  start_str, end_str = range_string.split('-')
  [start_str.to_i, end_str.to_i]
end

def omit_not_even_digit_numbers(range)
  min = range[0]
  max = range[1]
  min_length = min.to_s.length
  max_length = max.to_s.length
  result = []

  result[0] = min_length.even? ? min : 10**min_length
  result[1] = max_length.even? ? max : (10**max_length) - 1
  result
end

main