require 'aoc_utils'

def main
  start_time = Time.now
  #part1
  part2
  end_time = Time.now
  puts "\nExecution Time: #{(end_time - start_time)*1000} ms"

end

# === Part2 ===
def part2
  lines = AocUtils.read_chars('Day 7/input.txt')
  start_index = lines[0].index('S')
  beam_indices_and_counts = { start_index => 1 }
  print(count_beam_timelines(lines[1..], beam_indices_and_counts))
end

def count_beam_timelines(lines, beam_indices_and_counts)
  lines.each do |line|
    new_beam_indices_and_counts = Hash.new(0)
    beam_indices_and_counts.each do |beam, count|
      if line[beam] == '^'
        new_beam_indices_and_counts[beam - 1] += count unless beam - 1 < 0
        new_beam_indices_and_counts[beam + 1] += count unless beam + 1 >= line.length
      else
        new_beam_indices_and_counts[beam] += count
      end
    end
    beam_indices_and_counts = new_beam_indices_and_counts
  end
  beam_indices_and_counts.values.sum
end

# === Part1 ===
def part1
  lines = AocUtils.read_chars('Day 7/input.txt')
  start_index = lines[0].index('S')
  beam_indices = [start_index]
  print(count_beam_splits(lines[1..], beam_indices))
end

def count_beam_splits(lines, beam_indices)
  beam_splits = 0
  lines.each do |line|
    new_beam_indices = []
    beam_indices.each do |beam|
      if line[beam] == '^'
        beam_splits += 1
        new_beam_indices << beam - 1 unless beam - 1 < 0
        new_beam_indices << beam + 1 unless beam + 1 >= line.length
      else
        new_beam_indices << beam
      end
    end
    new_beam_indices.uniq!
    beam_indices = new_beam_indices
  end
  beam_splits
end

main