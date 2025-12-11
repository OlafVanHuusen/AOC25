require 'aoc_utils'
def main
  start = Time.now
  #part1
  part2
  end_time = Time.now
  print "Execution Time: #{(end_time - start) * 1000} ms\n"
end

def part2
  lines = AocUtils.read_strings('Day 11/input.txt').flatten!
  devices = lines_to_devices(lines)
  @devices_to_ints, @ints_to_devices = map_devices_to_ints(devices)
  devices_ints = transform_devices_to_ints(devices)
  important_ones = %w[svr dac fft out].map { |d| @devices_to_ints[d] }.to_set
  devices_ints = collapse_connections(devices_ints, important_ones)
  print "Part 2: #{count_paths_from_collapsed("svr", "out", %w[dac fft], devices_ints)}\n"
end

def count_paths_from_collapsed(from, to, via, devices_ints)
  from_int = @devices_to_ints[from]
  to_int = @devices_to_ints[to]
  via_ints = via.map { |d| @devices_to_ints[d] }
  to_first = devices_ints[from_int][via_ints[0]]
  to_second = devices_ints[from_int][via_ints[1]]
  first_to_second = devices_ints[via_ints[0]][via_ints[1]]
  second_to_first = devices_ints[via_ints[1]][via_ints[0]]
  second_to_out = devices_ints[via_ints[1]][to_int]
  first_to_out = devices_ints[via_ints[0]][to_int]
  total_paths = to_first * first_to_second * second_to_out + to_second * second_to_first * first_to_out
end

def collapse_connections(devices_ints, dont_collapse)
  devices = prep_data_structure(devices_ints)
  keys = devices.keys
  keys.each do |key|
    next if dont_collapse.include? key
    targets = devices[key]
    devices.each do |device, d_targets|
      paths_to_key = d_targets[key]
      next if paths_to_key == 0
      devices[device] = d_targets.zip(targets).map {|a, b| a + paths_to_key * b}
    end
    devices.delete(key)
  end
  devices
end

def prep_data_structure(devices_ints)
  length = devices_ints.length + 1
  devices = {}
  devices_ints.each do |d|
    d_arr = Array.new(length, 0)
    d[1].each do |target|
      d_arr[target] = 1
    end
    devices[d[0]] = d_arr
  end
  devices
end

def transform_devices_to_ints(devices)
  devices_ints = {}
  devices.each do |device, outputs|
    device_int = @devices_to_ints[device]
    outputs_ints = outputs.map { |output| @devices_to_ints[output] }
    devices_ints.store(device_int, outputs_ints)
  end
  devices_ints
end

def map_devices_to_ints(devices)
  device_to_int = {}
  int_to_device = {}
  devices.keys.to_set.merge(devices.values.flatten.to_set).to_a.sort!.to_set.each_with_index do |device, index|
    device_to_int.store(device, index)
    int_to_device.store(index, device)
  end
  [device_to_int, int_to_device]
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

def part1
  lines = AocUtils.read_strings('Day 11/input.txt').flatten!
  devices = lines_to_devices(lines)
  print "Part 1: #{find_count_of_paths(devices, "you", "out", Set.new)}\n"
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