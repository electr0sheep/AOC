# frozen_string_literal: true

$nodes_visited = 0
$nodes_visited_map = []
$nodes_visited_hash = {}

class Node # rubocop:disable Style/Documentation
  attr_accessor :came_from, :gscore, :fscore, :location, :direction

  def initialize(came_from, gscore, fscore, location, direction)
    @came_from = came_from
    @gscore = gscore
    @fscore = fscore
    @location = location
    @direction = direction
  end
end

def h(node, end_location)
  distance = [end_location[0] - node.location[0], end_location[1] - node.location[1]]
  turns_required = case node.direction
                   when 'UP'
                     if distance[1].negative?
                       3
                     elsif distance[0].zero?
                       2
                     else
                       1
                     end
                   when 'DOWN'
                     if distance[1].positive?
                       3
                     elsif distance[0].zero?
                       2
                     else
                       1
                     end
                   when 'LEFT'
                     if distance[0].negative?
                       3
                     elsif distance[1].zero?
                       2
                     else
                       1
                     end
                   when 'RIGHT'
                     if distance[0].positive?
                       3
                     elsif distance[1].zero?
                       2
                     else
                       1
                     end
                   end
  node.gscore + ((end_location[0] - node.location[0])).abs + ((end_location[1] - node.location[1])).abs + (1000 * turns_required)
end

def reconstruct_path(current)
  total_path = [current]
  until current.came_from.nil?
    current = current.came_from
    total_path.prepend(current)
  end
  total_path
end

def a_star(map, start_location, end_location, starting_direction)
  open_set = [Node.new(nil, 0, Float::INFINITY, start_location, starting_direction)]
  until open_set.empty?
    # open_set.each do |node|
    #   puts 'DUPLICATE NODES' if open_set.select { |n| n.location == node.location }.count > 1
    # end
    $nodes_visited += 1
    current = open_set.sort_by!(&:fscore).shift
    $nodes_visited_hash[current.location] = current
    # $nodes_visited_map[current.location[0]][current.location[1]] = '.'
    visual_map = []
    map.each do |r|
      visual_map << r.dup
    end
    visual_map[current.location[0]][current.location[1]] = '$'
    puts "[#{current.location[0]}, #{current.location[1]}]"
    return reconstruct_path(current) if current.location == end_location

    case current.direction
    when 'UP'
      if map[current.location[0] - 1][current.location[1]] != '#'
        node = Node.new(current, current.gscore + 1, nil, current.location.dup, 'UP')
        node.location[0] -= 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
      if map[current.location[0]][current.location[1] - 1] != '#'
        node = Node.new(current, current.gscore + 1001, nil, current.location.dup, 'LEFT')
        node.location[1] -= 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
      if map[current.location[0]][current.location[1] + 1] != '#'
        node = Node.new(current, current.gscore + 1001, nil, current.location.dup, 'RIGHT')
        node.location[1] += 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
    when 'DOWN'
      if map[current.location[0] + 1][current.location[1]] != '#'
        node = Node.new(current, current.gscore + 1, nil, current.location.dup, 'DOWN')
        node.location[0] += 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
      if map[current.location[0]][current.location[1] - 1] != '#'
        node = Node.new(current, current.gscore + 1001, nil, current.location.dup, 'LEFT')
        node.location[1] -= 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
      if map[current.location[0]][current.location[1] + 1] != '#'
        node = Node.new(current, current.gscore + 1001, nil, current.location.dup, 'RIGHT')
        node.location[1] += 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
    when 'LEFT'
      if map[current.location[0] - 1][current.location[1]] != '#'
        node = Node.new(current, current.gscore + 1001, nil, current.location.dup, 'UP')
        node.location[0] -= 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
      if map[current.location[0] + 1][current.location[1]] != '#'
        node = Node.new(current, current.gscore + 1001, nil, current.location.dup, 'DOWN')
        node.location[0] += 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
      if map[current.location[0]][current.location[1] - 1] != '#'
        node = Node.new(current, current.gscore + 1, nil, current.location.dup, 'LEFT')
        node.location[1] -= 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
    when 'RIGHT'
      if map[current.location[0] - 1][current.location[1]] != '#'
        node = Node.new(current, current.gscore + 1001, nil, current.location.dup, 'UP')
        node.location[0] -= 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
      if map[current.location[0] + 1][current.location[1]] != '#'
        node = Node.new(current, current.gscore + 1001, nil, current.location.dup, 'DOWN')
        node.location[0] += 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
      if map[current.location[0]][current.location[1] + 1] != '#'
        node = Node.new(current, current.gscore + 1, nil, current.location.dup, 'RIGHT')
        node.location[1] += 1
        if $nodes_visited_hash[node.location].nil?
          node.fscore = h(node, end_location)
          open_set << node
        elsif node.gscore < $nodes_visited_hash[node.location].gscore
          $nodes_visited_hash[node.location].gscore = node.gscore
          current_node = open_set.find { |n| n.location = node.location }
          if current_node
            current_node.gscore = node.gscore if node.gscore < current_node.gscore
          else
            open_set << node
          end
        end
      end
    end
  end
  raise StandardError, 'No route found'
end

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
map = input.split("\n").map { |r| r.split('') }
# map.count.times do |i|
#   $nodes_visited_map << []
#   map[0].count.times do
#     $nodes_visited_map[i] << ' '
#   end
# end
start_location = [
  map.find_index { |r| r.any? { |e| e == 'S' } },
  map.find { |r| r.any? { |e| e == 'S' } }.find_index { |e| e == 'S' }
]
end_location = [
  map.find_index { |r| r.any? { |e| e == 'E' } },
  map.find { |r| r.any? { |e| e == 'E' } }.find_index { |e| e == 'E' }
]

nodes = a_star(map, start_location, end_location, 'RIGHT')

puts $nodes_visited
# $nodes_visited_map.each do |r|
#   puts r.join('')
# end
puts nodes[nodes.count - 1].gscore
