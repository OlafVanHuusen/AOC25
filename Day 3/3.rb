require 'aoc_utils'

def main
  time_start = Time.now
  banks = AocUtils.read_chars('Day 3/testinput.txt')
  banks.map! { |num| num.map(&:to_i) }
  # === Part 1 ===
  print "Result Part 1: ", banks.reduce(0) { |sum, bank| sum + maximum_joltage(bank, 2) }, "\n"
  # === Part 2 ===
  print "Result Part 2: ", banks.reduce(0) { |sum, bank| sum + maximum_joltage(bank, 12) }, "\n"
  # === End ===
  time_end = Time.now
  puts "\nExecution Time: #{(time_end - time_start) * 1000} ms"
end

def maximum_joltage(bank, n_batteries)
  values = []
  n_batteries.downto(1) do |i|
    leftmost_max_index_i = bank[0..-i].find_index(bank[0..-i].max)
    values << bank[leftmost_max_index_i]
    bank = bank[(leftmost_max_index_i + 1)..-1]
  end
  values.reduce(""){|string, element| string + element.to_s}.to_i
end

main