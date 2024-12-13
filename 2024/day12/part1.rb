# frozen_string_literal: true

# This is used to disallow array access that go outside the bounds of the array
# Ruby allows things like array[-1] to access the last element in the array and
# array[array.length] == nil when most other languages would throw an error
# That's great, but we don't want any of that
# I sure wish I could find an easier way to do this. Extending this crap every time
# I modify the array is annoying af
module PreciseIndexing
  def [](index)
    raise IndexError, 'Index out of bounds' if index.negative? || index >= length

    super(index)
  end
end

def process_square(y, x, target_plot, map)
  area = 0
  perimeter = 0
  return [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area, perimeter] if map[y][x] == '.'
  return [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area, perimeter + 1] if map[y][x] != target_plot

  map[y][x] = '.'
  area += 1

  map, area2, perimeter2 = process_square(y - 1, x, target_plot, map)
  area += area2
  perimeter += perimeter2

  map, area2, perimeter2 = process_square(y + 1, x, target_plot, map)
  area += area2
  perimeter += perimeter2

  map, area2, perimeter2 = process_square(y, x - 1, target_plot, map)
  area += area2
  perimeter += perimeter2

  map, area2, perimeter2 = process_square(y, x + 1, target_plot, map)
  area += area2
  perimeter += perimeter2

  [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area, perimeter]
rescue IndexError
  [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area, perimeter + 1]
rescue NoMethodError
  [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area, perimeter + 1]
end

def clear_map(map)
  map.map { |r| r.map { |c| c == '.' ? nil : c }.extend(PreciseIndexing) }.extend(PreciseIndexing)
end

def print_map(map)
  map.each do |row|
    puts row.map { |r| r.nil? ? ' ' : r }.join('')
  end
end

score = 0
input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
map = input.split("\n").map { |i| i.split('').extend(PreciseIndexing) }.extend(PreciseIndexing)
map.count.times do |y|
  map[y].count.times do |x|
    next if map[y][x].nil? || map[y][x] == '.'

    map, area, perimeter = process_square(y, x, map[y][x], map)
    score += area * perimeter
    map = clear_map(map)
    # print_map(map)
    # test = 1
  end
end
puts score
