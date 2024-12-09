# frozen_string_literal: true

def possible?(scenario, index, sum)
  return false if sum < scenario[:test_value] && scenario[:numbers][index].nil?
  return false if sum > scenario[:test_value]
  return true if sum == scenario[:test_value] && scenario[:numbers][index].nil?

  possible?(scenario, index + 1, sum + scenario[:numbers][index]) ||
    possible?(scenario, index + 1, sum * scenario[:numbers][index])
end

result = 0
input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
lines = input.split("\n")
scenarios = lines.map { |l| { test_value: l.split(': ')[0].to_i, numbers: l.split(': ')[1].split(' ').map(&:to_i) } }

scenarios.each do |scenario|
  result += scenario[:test_value] if possible?(scenario, 1, scenario[:numbers][0])
end

puts result