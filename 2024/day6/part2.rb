# Here is where things start getting hard

module PreciseIndexing
  def [](index)
    raise IndexError, "Index out of bounds" if index < 0 || index >= self.length
    super(index)
  end
end

def move_left(array, current_position)
  next_position = current_position.dup
  next_position[1] -= 1
  if array[next_position[0]][next_position[1]] == '#'
    return current_position, 'UP'
  end
  array[next_position[0]][next_position[1]] = 'X'
  return next_position, 'LEFT'
end

def move_right(array, current_position)
  next_position = current_position.dup
  next_position[1] += 1
  if array[next_position[0]][next_position[1]] == '#'
    return current_position, 'DOWN'
  end
  array[next_position[0]][next_position[1]] = 'X'
  return next_position, 'RIGHT'
end

def move_up(array, current_position)
  next_position = current_position.dup
  next_position[0] -= 1
  if array[next_position[0]][next_position[1]] == '#'
    return current_position, 'RIGHT'
  end
  array[next_position[0]][next_position[1]] = 'X'
  return next_position, 'UP'
end

def move_down(array, current_position)
  next_position = current_position.dup
  next_position[0] += 1
  if array[next_position[0]][next_position[1]] == '#'
    return current_position, 'LEFT'
  end
  array[next_position[0]][next_position[1]] = 'X'
  return next_position, 'DOWN'
end

def get_starting_position(array)
  array.each_with_index do |row, r|
    row.each_with_index do |column, c|
      if column == '^'
        array[r][c] = 'X'
        return [r,c]
      end
    end
  end
end

def count_xes(array)
  result = 0

  array.each do |row|
    row.each do |column|
      result += 1 if column == 'X'
    end
  end

  result
end

current_direction = 'UP'
input = File.read(File.join(File.dirname(__FILE__), 'sample.txt'))
map = input.split("\n").map { |e| e.split('') }
current_pos = get_starting_position(map)
map.extend PreciseIndexing
map.each { |a| a.extend PreciseIndexing }

begin
  while true
    case current_direction
    when 'UP'
      current_pos, current_direction = move_up(map, current_pos)
    when 'DOWN'
      current_pos, current_direction = move_down(map, current_pos)
    when 'LEFT'
      current_pos, current_direction = move_left(map, current_pos)
    when 'RIGHT'
      current_pos, current_direction = move_right(map, current_pos)
    end
  end
rescue IndexError
  puts count_xes(map)
end