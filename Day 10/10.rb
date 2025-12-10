require 'aoc_utils'
require 'z3'

def main
  start_time = Time.now
  #part1
  part2
  end_time = Time.now
  print "Execution Time: #{(end_time - start_time)*1000} ms\n"
end


# === PART 2 ===
def part2
  buttons = []
  joltages = []
  File.open('Day 10/input.txt').each_line do |line|
    buttons << line.scan(/\(([^)]+)\)/).map { |match| match[0].split(',').map(&:to_i) }
    joltages << line.match(/\{([^}]+)}/)[1].split(',').map(&:to_i)
  end
  buttons.map! { |button_set| transform_to_binary(button_set, button_set.flatten.max + 1) }
  print "Result Part 2: #{minimum_buttons_for_joltage(joltages, buttons)}\n"
end

def solve_csp(buttons, target_arr)
  optimizer = Z3::Optimize.new
  x = buttons.length.times.map { |i| Z3.Int("x_#{i}") }
  x.each { |var| optimizer.assert(var >= 0) }

  target_arr.each_with_index do |target_num, at_index|
    axis_sum = Z3.Add(*buttons.each_with_index.map { |b, i| Z3.Mul(x[i], b[at_index]) })
    optimizer.assert(axis_sum == target_num)
  end

  total_presses = Z3.Add(*x)
  optimizer.minimize(total_presses)
  if optimizer.check == :sat
    model = optimizer.model
    x.map { |var| model[var].to_i }.sum
  else
    nil
  end
end

def minimum_buttons_for_joltage(joltages, buttons)
  minimum_presses_sum = 0
  joltages.each_with_index do |joltage, index|
    result = solve_csp(buttons[index], joltage)
    if result.nil?
      raise "No solution found for target #{joltage}"
    end
    minimum_presses_sum += result
  end
  minimum_presses_sum
end

def transform_to_binary(buttons, length)
  buttons_new = []
  buttons.each do |button|
    binary_button = Array.new(length, 0)
    button.each do |position|
      binary_button[position] = 1
    end
    buttons_new << binary_button
  end
  buttons_new
end


# === PART 1 ===
def part1
  indicator_lights = []
  buttons = []
  File.open('Day 10/input.txt').each_line do |line|
    indicator_lights << line.match(/\[([^\]]+)\]/)[1].chars.map { |char| char == '#' ? 1 : 0 }
    buttons << line.scan(/\(([^)]+)\)/).map { |match| match[0].split(',').map(&:to_i) }
  end
  print "Result Part 1: #{minimum_switches_for_lights(indicator_lights, buttons)}\n"
end

def minimum_switches_for_lights(indicator_lights, buttons)
  minimum_switches_sum = 0
  indicator_lights.each_with_index do |target_lights, index|
    buttons_for_light = buttons[index]
    starting_state = Array.new(target_lights.length, 0)
    queue = [[starting_state, 0]]
    visited = {}
    found = false
    while !queue.empty? && !found
      current_state, switch_count = queue.shift
      next if visited[current_state]
      visited[current_state] = true
      if current_state == target_lights
        minimum_switches_sum += switch_count
        found = true
        break
      end
      buttons_for_light.each do |button|
        new_state = current_state.dup
        button.each do |position|
          new_state[position] = 1 - new_state[position]
        end
        queue << [new_state, switch_count + 1]
      end
    end
  end
  minimum_switches_sum
end

main