# frozen_string_literal: true

# This is used to disallow array access that go outside the bounds of the array
# Ruby allows things like array[-1] to access the last element in the array and
# array[array.length] == nil when most other languages would throw an error
# That's great, but we don't want any of that
module PreciseIndexing
  def [](index)
    raise IndexError, 'Index out of bounds' if index.negative? || index >= length

    super(index)
  end
end

def map_antinodes(antennae, y, x, antinodes)
  signal = antennae[y][x]
  antennae[y][x] = '.'
  antennae.each_with_index do |row, y2|
    row.each_with_index do |column, x2|
      next unless column == signal

      slope = y - y2, x - x2
      antinode1_index = y + slope[0], x + slope[1]
      antinode2_index = y2 - slope[0], x2 - slope[1]
      begin
        antinodes[antinode1_index[0]][antinode1_index[1]] << signal
      rescue IndexError
      end
      begin
        antinodes[antinode2_index[0]][antinode2_index[1]] << signal
      rescue IndexError
      end
    end
  end
end

result = 0
input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
antennae = input.split("\n").map { |i| i.split('').extend(PreciseIndexing) }.extend(PreciseIndexing)
antinodes = antennae.dup.map { |y| y.map { |_| [] }.extend(PreciseIndexing) }.extend(PreciseIndexing)

antennae.each_with_index do |row, y|
  row.each_with_index do |column, x|
    map_antinodes(antennae, y, x, antinodes) if column != '.'
  end
end

antinodes.each do |row|
  row.each do |column|
    result += 1 unless column.empty?
  end
end

puts result
