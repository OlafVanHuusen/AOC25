require 'aoc_utils'

def main
  time_start = Time.now
  banks = AocUtils.read_chars('Day 3/input.txt')
  banks = char_arr_to_int_arr(banks)
  # === Part 1 ===
  print banks.reduce(0) { |sum, bank| sum + maximum_joltage(bank, 2) }
  # === Part 2 ===
  print banks.reduce(0) { |sum, bank| sum + maximum_joltage_part2(bank, 12) }
  # === End ===
  time_end = Time.now
  puts "\nExecution Time: #{(time_end - time_start) * 1000} ms"
end

# === Part 2 ===

def maximum_joltage_part2(bank, n_batteries)
  values = []
  n_batteries.downto(1) do |i|
    leftmost_max_index_i = bank[0..-i].find_index(bank[0..-i].max)
    values << bank[leftmost_max_index_i]
    bank = bank[(leftmost_max_index_i + 1)..-1]
  end
  values.reduce(""){|string, element| string + element.to_s}.to_i
end

# === Part 1 ===
def maximum_joltage(bank)
  leftmost_max_index = bank[0..-2].find_index(bank[0..-2].max)
  second_max_index = bank[leftmost_max_index + 1..-1].find_index(bank[leftmost_max_index + 1..-1].max)
  second_max_index += leftmost_max_index + 1
  (bank[leftmost_max_index].to_s + bank[second_max_index].to_s).to_i
end

def char_arr_to_int_arr(arr)
  arr.map { |num| num.map(&:to_i) }
end

main