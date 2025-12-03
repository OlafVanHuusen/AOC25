require 'aoc_utils'

def main
  start_time = Time.now
  left_rights = []
  input = AocUtils.read_ints('Day 1/input.txt', left_rights).flatten
  left_rights.map! { |char| char == 'L' ? -1 : 1 }
  # === Part 1 ===
  #print (0...input.length).reduce([50, 0]) { |info, x| info[0] = (info[0] + left_rights[x] * input[x]) % 100; info[1] += info[0] == 0 ? 1 : 0; info }
  # === Part 2 ===
  infos = (0...input.length).reduce([50, 0]) do |info, x|
    full_rotations = input[x] / 100
    info[1] += full_rotations
    input[x] -= full_rotations * 100
    was_zero = info[0] == 0
    info[0] = (info[0] + left_rights[x] * input[x])
    if info[0] >= 100 || info[0] < 0
      info[1] += 1 if !was_zero
      info[0] = info[0] % 100
    elsif info[0] == 0
      info[1] += 1
    end
  info
  end
  print infos
  end_time = Time.now
  execution_time = end_time - start_time
  puts "\nExecution time: #{execution_time} seconds"
end


main