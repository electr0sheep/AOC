def parse_instruction(string, index)
  return 0 if string[index..index + 3] != 'mul('
  matching_paren_bracket_index = string[index..-1].index(')') + index
  return 0 if matching_paren_bracket_index - index > 11
  numbers = string[index + 4..matching_paren_bracket_index - 1].split(',')
  return 0 if !(numbers[0] !~ /\D/)
  return 0 if !(numbers[1] !~ /\D/)
  num1 = numbers[0].to_i
  num2 = numbers[1].to_i
  num1 * num2
end

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
result = 0
(0..input.length - 1).each do |n|
  result += parse_instruction(input, n) if input[n] == 'm'
end

puts result