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

def calculate_sides(original_y, original_x, target_plot, map, direction_of_travel)
  sides = 1
  y = original_y
  x = original_x

  # initialize direction of travel
  if map[y + 1][x] == target_plot
    y += 1
    direction_of_travel = 'UP'
  elsif map[y][x + 1] == target_plot
    x += 1
    direction_of_travel = 'RIGHT'
  elsif map[y - 1][x] == target_plot
    y -= 1
    direction_of_travel = 'DOWN'
  elsif map[y][x - 1] == target_plot
    x -= 1
    direction_of_travel == 'LEFT'
  else
    return 4
  end

  while x != original_x && y != original_y && direction_of_travel != 'UP'
    case direction_of_travel
    when 'UP'
      if map[y][x - 1] == target_plot
        sides += 1
        direction_of_travel = 'LEFT'
      elsif map[y - 1][x] == target_plot
        y -= 1
      else
        sides += 1
        direction_of_travel = 'RIGHT'
      end
    when 'LEFT'
      if map[y + 1][x] == target_plot
        sides += 1
        direction_of_travel = 'DOWN'
      else
        x -= 1
      end
    when 'DOWN'
      if map[]
    when 'RIGHT'
    else
      raise StandardError, 'wtf?'
    end
  end

  sides
end

# OOOOOOOOOOOOOO
# OOOOOXOOOOOOOO
# OOOXXXXXXOOOOO
# OOOXXXXXXOOOOO
# OOOXXOXXXOOOOO
# OOOOOOOOOOOOOO
# OOOOOOOOOOOOOO
# OOOOOOOOOOOOOO

def calculate_area(y, x, target_plot, map)
  area = 0
  return [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area] if map[y][x] == '.'
  return [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area] if map[y][x] != target_plot

  map[y][x] = '.'
  area += 1

  map, area2 = calculate_area(y - 1, x, target_plot, map)
  area += area2

  map, area2 = calculate_area(y + 1, x, target_plot, map)
  area += area2

  map, area2 = calculate_area(y, x - 1, target_plot, map)
  area += area2

  map, area2 = calculate_area(y, x + 1, target_plot, map)
  area += area2

  [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area]
rescue IndexError
  [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area]
rescue NoMethodError
  [map.map { |r| r.extend(PreciseIndexing) }.extend(PreciseIndexing), area]
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
input = File.read(File.join(File.dirname(__FILE__), 'sample.txt'))
map = input.split("\n").map { |i| i.split('').extend(PreciseIndexing) }.extend(PreciseIndexing)
map.count.times do |y|
  map[y].count.times do |x|
    next if map[y][x].nil? || map[y][x] == '.'

    sides = calculate_sides(y, x, map[y][x], map, 'UP')
    map, area = calculate_area(y, x, map[y][x], map)
    score += area * sides
    map = clear_map(map)
    # print_map(map)
    # test = 1
  end
end
puts score
