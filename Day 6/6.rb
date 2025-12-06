require 'aoc_utils'

def main
  start_time = Time.now
=begin
  # === Part 1 ===
  numbers, operators = AocUtils.read_two_parts('Day 6/testinput.txt', 'Integer', 'Char')
  operators.flatten!.filter! { |op| op == "+" || op == "*" }
  sum = 0
  operators.each_with_index do |op, index|
    if op == "+"
      sum += numbers.reduce(0){ |sum, row| sum + row[index] }
    elsif op == "*"
      sum += numbers.reduce(1){ |prod, row| prod * row[index] }
    end
  end
  print "Part 1: #{sum}\n"
=end
  # === Part 2 ===
  numbers, operators = AocUtils.read_two_parts('Day 6/input.txt', 'Char', 'Char')
  operators.flatten!
  start_index, sum = 0, 0
  while start_index < numbers.map { |row| row.length }.max
    next_op_index = find_next_op(operators, start_index, numbers)
    operator = operators[start_index]
    local_sum = operator == "+" ? 0 : 1
    (start_index...next_op_index).each do |i|
      num = build_number_from_index(numbers, i)
      if num == -1
        next
      end
      if operator == "+"
        local_sum += num
      elsif operator == "*"
        local_sum *= num
      end
    end
    sum += local_sum
    start_index = next_op_index
  end
  print "Part 2: #{sum}\n"

  end_time = Time.now
  print "Time taken: #{(end_time - start_time) * 1000} ms\n"
end

def build_number_from_index(numbers, index)
  number = ""
  numbers.each do |row|
    number += row[index].to_s
  end
  ret_rum = number.to_i
  if ret_rum == 0
    return -1
  end
  ret_rum
end

def find_next_op(operators, index, numbers)
  operators[index + 1..] .each_with_index do |op, i|
    return index + i + 1 if op == "+" || op == "*"
  end
  numbers.map { |row| row.length }.max
end

main