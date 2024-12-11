# frozen_string_literal: true

def blink(stones)
  new_stones = []

  stones.each do |stone|
    if stone == '0'
      new_stones << '1'
    elsif stone.length.even?
      new_stones << stone[0..(stone.length / 2) - 1].to_i.to_s
      new_stones << stone[(stone.length / 2)..].to_i.to_s
    else
      new_stones << (stone.to_i * 2024).to_s
    end
  end

  new_stones
end

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
stones = input.split(' ')

25.times do
  stones = blink(stones)
end

puts stones.length
