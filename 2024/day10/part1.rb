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

# only copies one level, so not really deep, but screw it
def deep_dup(array)
  new_ar = []
  array.each_with_index do |r, i|
    new_ar << []
    r.each do |c|
      new_ar[i] << c
    end
  end
  new_ar
end

def calculate_trail_score(map, y, x, current_number)
  return 0 if map[y][x] != current_number

  if current_number == 9 && map[y][x] == 9
    map[y][x] = 0
    return 1
  end

  calculate_trail_score(map, y - 1, x, current_number + 1) +
    calculate_trail_score(map, y + 1, x, current_number + 1) +
    calculate_trail_score(map, y, x - 1, current_number + 1) +
    calculate_trail_score(map, y, x + 1, current_number + 1)
rescue IndexError
  0
end

score = 0
input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
map = input.split("\n").map { |i| i.split('').map(&:to_i).extend(PreciseIndexing) }.extend(PreciseIndexing)

map.each.with_index do |row, y|
  row.each_with_index do |column, x|
    new_map = deep_dup(map).each { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing)
    score += calculate_trail_score(new_map, y, x, 0) if column.zero?
  end
end

puts score
