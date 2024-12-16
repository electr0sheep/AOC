# frozen_string_literal: true

# MAX_HEIGHT = 7
# MAX_WIDTH = 11
MAX_HEIGHT = 103
MAX_WIDTH = 101

def score_quadrants(robots)
  quad_one_robot_count = 0
  quad_two_robot_count = 0
  quad_three_robot_count = 0
  quad_four_robot_count = 0

  robots.each do |robot|
    position = robot[:position]
    next if position[0] == MAX_WIDTH / 2 || position[1] == MAX_HEIGHT / 2

    quad_one_robot_count += 1 if position[0] < MAX_WIDTH / 2 && position[1] < MAX_HEIGHT / 2
    quad_two_robot_count += 1 if position[0] > MAX_WIDTH / 2 && position[1] < MAX_HEIGHT / 2
    quad_three_robot_count += 1 if position[0] < MAX_WIDTH / 2 && position[1] > MAX_HEIGHT / 2
    quad_four_robot_count += 1 if position[0] > MAX_WIDTH / 2 && position[1] > MAX_HEIGHT / 2
  end

  quad_one_robot_count * quad_two_robot_count * quad_three_robot_count * quad_four_robot_count
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

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
robots = input.split("\n").map do |r|
  {
    position: r.split('p=')[1].split(' v=')[0].split(',').map(&:to_i),
    velocity: r.split('v=')[1].split(',').map(&:to_i)
  }
end

100.times do
  move_robots(robots)
end

puts score_quadrants(robots)
