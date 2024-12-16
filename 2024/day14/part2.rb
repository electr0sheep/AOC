# I'm not super happy with this one. I feel like to come up with an actual solution to the
# "Do the robots make a christmas tree" problem is insanely complicated. Isn't this exact
# thing what captchas are supposed to prevent? For this particular problem, it just so
# happened that the solution presented itself when no two robots occupied the same space
# (thanks Reddit), but there is absolutely no gaurantee that would be the case. In addition,
# simply looking for a bunch of occupied spaces in a row also is no gaurantee. There are many
# shapes that could look like a christmas tree. My only consoliation is that I think my mistake
# was I should have realized the context was I was doing AOC, so the solution probably wouldn't
# be as hard as an actual real solution. Also from Reddit: https://xkcd.com/1425/

# frozen_string_literal: true

# MAX_HEIGHT = 7
# MAX_WIDTH = 11
MAX_HEIGHT = 103
MAX_WIDTH = 101
# MAX_HEIGHT = 7
# MAX_WIDTH = 3

def print_alleged_tree(robots)
  array = []
  MAX_HEIGHT.times do |y|
    row_array = []
    MAX_WIDTH.times do
      row_array << '.'
    end
    array << row_array
  end

  robots.map { |r| r[:position] }.each do |position|
    array[position[1]][position[0]] = 'X'
  end

  array.each { |a| puts a.join('') }
end

def no_robots_occupy_same_space?(robots)
  robots.each do |robot|
    position = robot[:position]
    return false if robots.map { |r| r[:position] }.select { |p| p[0] == position[0] && p[1] == position[1] }.count > 1
  end

  true
end

def symmetric_robots?(robots, axis)
  robots.each do |robot|
    position = robot[:position]
    mirrored_position = axis == 'x' ? [MAX_WIDTH - position[0] - 1, position[1]] : [position[0], MAX_HEIGHT - position[1] - 1]
    return false unless robots.map { |r| r[:position] }.any? { |p| p[0] == mirrored_position[0] && p[1] == mirrored_position[1] }
    # mirrored_position = position[0] < MAX_WIDTH / 2 ? [MAX_WIDTH - position[0], position[1]] : [position[0], [position[1]]]
  end

  true
end

def wrap_position(robot)
  robot[:position][0] = MAX_WIDTH + robot[:position][0] if (robot[:position][0]).negative?
  robot[:position][0] = robot[:position][0] - MAX_WIDTH if robot[:position][0] >= MAX_WIDTH
  robot[:position][1] = MAX_HEIGHT + robot[:position][1] if (robot[:position][1]).negative?
  robot[:position][1] = robot[:position][1] - MAX_HEIGHT if robot[:position][1] >= MAX_HEIGHT
end

def move_robots(robots)
  robots.each do |robot|
    robot[:position][0] += robot[:velocity][0]
    robot[:position][1] += robot[:velocity][1]
    wrap_position(robot)
  end
end

moves = 0
input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
robots = input.split("\n").map do |r|
  {
    position: r.split('p=')[1].split(' v=')[0].split(',').map(&:to_i),
    velocity: r.split('v=')[1].split(',').map(&:to_i)
  }
end

# puts symmetric_robots?(robots, 'x')
# puts no_robots_occupy_same_space?(robots)

until no_robots_occupy_same_space?(robots)
  raise StandardError, 'Nope' if moves > MAX_HEIGHT.lcm(MAX_WIDTH)

  move_robots(robots)
  moves += 1
end

print_alleged_tree(robots)

puts moves
