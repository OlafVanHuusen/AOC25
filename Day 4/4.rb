require 'aoc_utils'

def main
  startTime = Time.now
  area = AocUtils.read_chars('Day 4/input.txt')
  area.map! { |line| line.map { |char| char == '@' ? 1 : 0 } }
  #print part1(area), "\n"
  print part2(area), "\n"
  endTime = Time.now
  puts "Execution Time: #{(endTime - startTime) * 1000} ms"
end

def part2(area)
  original_sum = area.flatten.sum
  sum = -1
  sum_new = 0
  while sum != sum_new
    sum = sum_new
    area = convolution(area)
    sum_new = area.flatten.sum
  end
  original_sum - sum_new
end

def part1(area)
  old_sum = area.flatten.sum
  new_sum = convolution(area).flatten.sum
  old_sum - new_sum
end

def convolution(matrix)
  h, w = matrix.length, matrix[0].length
  result = Array.new(h) { Array.new(w, 0) }
  (0...h).each { |i|
    (0...w).each { |j|
      next if matrix[i][j] == 0
      sum = 0
      (-1..1).each { |m|
        (-1..1).each { |n|
          ni = i + m
          nj = j + n
          if ni >= 0 && ni < h && nj >= 0 && nj < w && matrix[ni][nj] == 1
            sum += 1
          end
        }
      }
      result[i][j] = sum < 5 ? 0 : 1
    }
  }
  result
end

main