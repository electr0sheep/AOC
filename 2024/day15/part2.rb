# frozen_string_literal: true

def score_boxes(map)
  score = 0
  map.each_with_index do |row, y|
    row.each_with_index do |e, x|
      score += 100 * y + x if e == 'O'
    end
  end

  score
end

def shift(ar)
  (1..ar.count).each do |i|
    return ar if ar[i] == '#'

    next unless ar[i] == '.'

    ar[i] = 'O'
    ar[0] = '.'
    ar[1] = '@'
    break
  end

  ar
end

def move_robot(map, direction)
  robot_position = [
    map.find_index { |row| row.any? { |r| r == '@' } },
    map.select { |row| row.any? { |r| r == '@' } }[0].find_index { |e| e == '@' }
  ]
  case direction
  when '<'
    post_shift = shift(map[robot_position[0]][..robot_position[1]].reverse)
    map[robot_position[0]][..robot_position[1]] = post_shift.reverse
  when '>'
    post_shift = shift(map[robot_position[0]][robot_position[1]..])
    map[robot_position[0]][robot_position[1]..] = post_shift
  when '^'
    column = map.map { |r| r[robot_position[1]] }
    post_shift = shift(column[..robot_position[0]].reverse).reverse
    post_shift.each_with_index do |e, i|
      map[i][robot_position[1]] = e
    end
  when 'v'
    column = map.map { |r| r[robot_position[1]] }
    post_shift = shift(column[robot_position[0]..])
    post_shift.each_with_index do |e, i|
      map[robot_position[0] + i][robot_position[1]] = e
    end
  end
end

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
map = input.split("\n\n")[0].split("\n").map { |r| r.split('') }
moves = input.split("\n\n")[1].split("\n").join('').split('')

moves.each do |move|
  move_robot(map, move)
end

puts score_boxes(map)
