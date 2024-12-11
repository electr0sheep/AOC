# frozen_string_literal: true

def blink(stone_map)
  new_stones = {}

  stone_map.each do |value, count|
    if value == '0'
      new_stones['1'] = 0 if new_stones['1'].nil?
      new_stones['1'] += count
    elsif value.length.even?
      first_value = value[0..(value.length / 2) - 1].to_i.to_s
      second_value = value[(value.length / 2)..].to_i.to_s
      new_stones[first_value] = 0 if new_stones[first_value].nil?
      new_stones[second_value] = 0 if new_stones[second_value].nil?
      new_stones[first_value] += count
      new_stones[second_value] += count
    else
      value = (value.to_i * 2024).to_s
      new_stones[value] = 0 if new_stones[value].nil?
      new_stones[value] += count
    end
  end

  new_stones
end

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
stones = input.split(' ')
stone_map = {}

stones.each do |stone|
  stone_map[stone] = 0 if stone_map[stone].nil?
  stone_map[stone] += 1
end

75.times do |i|
  puts i
  stone_map = blink(stone_map)
end

puts stone_map.values.sum
