require 'aoc_utils'

def main
  start_time = Time.now
  #part1
  part2
  end_time = Time.now
  puts "Execution time: #{end_time - start_time} seconds"
end

def part2
  jboxes = AocUtils.read_ints('Day 8/input.txt')
  closest_jboxes_pairs = find_closest_pairs(jboxes, jboxes.length**2)
  result = build_circuits_part2(closest_jboxes_pairs, jboxes)
  puts "Part 2: #{result}"
end

def build_circuits_part2(closest_jboxes_pairs, jboxes)
  circuits = []
  closest_jboxes_pairs.each do |pair|
    j1, j2 = pair[:jboxes]
    circuit_j1 = circuits.find { |circuit| circuit.include?(j1) }
    circuit_j2 = circuits.find { |circuit| circuit.include?(j2) }
    if circuit_j1 && circuit_j2
      if circuit_j1 == circuit_j2
        next
      end
      circuit_j1.concat(circuit_j2)
      circuits.delete(circuit_j2)
      if circuits.length == 1 && circuits[0].length == jboxes.length
        return jboxes[j1][0]*jboxes[j2][0]
      end
    elsif circuit_j1
      circuit_j1 << j2
      if circuits.length == 1 && circuits[0].length == jboxes.length
        return jboxes[j1][0]*jboxes[j2][0]
      end
    elsif circuit_j2
      circuit_j2 << j1
      if circuits.length == 1 && circuits[0].length == jboxes.length
        return jboxes[j1][0]*jboxes[j2][0]
      end
    else
      circuits << [j1, j2]
    end
  end
  0
end


def part1
  jboxes = AocUtils.read_ints('Day 8/input.txt')
  closest_jboxes_pairs = find_closest_pairs(jboxes, 1000)
  circuits = build_circuits(closest_jboxes_pairs)
  result = circuits.sort! { |a, b| b.length <=> a.length }[0..2].map(&:length).reduce(1, :*)
  puts "Part 1: #{result}"
end

def build_circuits(closest_jboxes_pairs)
  circuits = []
  closest_jboxes_pairs.each do |pair|
    j1, j2 = pair[:jboxes]
    circuit_j1 = circuits.find { |circuit| circuit.include?(j1) }
    circuit_j2 = circuits.find { |circuit| circuit.include?(j2) }
    if circuit_j1 && circuit_j2
      if circuit_j1 == circuit_j2
        next
      end
      circuit_j1.concat(circuit_j2)
      circuits.delete(circuit_j2)
    elsif circuit_j1
      circuit_j1 << j2
    elsif circuit_j2
      circuit_j2 << j1
    else
      circuits << [j1, j2]
    end
  end
  circuits
end

def find_closest_pairs(jboxes, cutoff = 1000)
  closest_jboxes_pairs = []
  jboxes.each_with_index do |jbox, i|
    jboxes[i + 1..].each_with_index do |jbox2, j|
      distance = ((jbox[0] - jbox2[0]).abs**2 + (jbox[1] - jbox2[1]).abs**2 + (jbox[2] - jbox2[2]).abs**2)**0.5
      closest_jboxes_pairs << { distance: distance, jboxes: [i, j + i + 1] }
    end
  end
  closest_jboxes_pairs.sort_by! { |pair| pair[:distance] }
  closest_jboxes_pairs[...cutoff]
end

main