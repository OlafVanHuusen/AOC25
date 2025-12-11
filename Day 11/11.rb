require 'aoc_utils'

def main
  start = Time.now
  #part1
  part2
  end_time = Time.now
  print "Execution Time: #{(end_time - start) * 1000} ms\n"
end

def part2
  lines = AocUtils.read_strings('Day 11/testinput.txt').flatten!
  devices = lines_to_devices(lines)
  devices = collapse_connections(devices, %w[svr, dac, fft, out])
  print "Part 2: #{find_count_of_paths_via(devices, "svr", "out", Set.new, %w[dac fft])}\n"
end

def part1
  lines = AocUtils.read_strings('Day 11/testinput.txt').flatten!
  devices = lines_to_devices(lines)
  print "Part 1: #{find_count_of_paths(devices, "you", "out", Set.new)}\n"
end

def collapse_connections(devices, dont_collapse)
  collapsed = {}
  changed = false
  devices.each do |device, outputs|
    next if dont_collapse.include?(device) || outputs.to_set.superset?(dont_collapse.to_set)

  end
  collapsed
end

def find_count_of_paths_via(devices, curr, out, visited, to_visit)
  if curr == out
    return (to_visit - visited.to_a).empty? ? 1 : 0
  end
  visited.add(curr)
  path_count = 0
  devices[curr].each do |next_device|
    unless visited.include?(next_device)
      path_count += find_count_of_paths_via(devices, next_device, out, visited, to_visit)
    end
  end
  visited.delete(curr)
  path_count
end

def find_count_of_paths(devices, curr, out, visited)
  return 1 if curr == out
  visited.add(curr)
  path_count = 0
  devices[curr].each do |next_device|
    unless visited.include?(next_device)
      path_count += find_count_of_paths(devices, next_device, out, visited)
    end
  end
  visited.delete(curr)
  path_count
end

def lines_to_devices(lines)
  devices = {}
  lines.each do |line|
    split = line.strip.split(":")
    name = split[0]
    outputs = split[1].split(" ").map(&:strip)
    devices.store(name, outputs)
  end
  devices
end

main