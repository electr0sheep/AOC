def middle_element(array)
  array[(array.length - 1) / 2]
end

def update_valid?(array, rules_map)
  array.each_with_index do |element, i|
    elements_that_must_appear_after = rules_map[element]
    next if elements_that_must_appear_after.nil?
    elements_that_must_appear_after.each do |number|
      next if !array.include?(number)
      (i + 1..array.length).each do |i2|
        break if array[i2] == number
        return false if array[i2].nil?
      end
    end
  end
  true
end

result = 0
input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
rules = input.split("\n\n")[0].split("\n").map { |r| r.split('|').map { |n| n.to_i } }
updates = input.split("\n\n")[1].split("\n").map { |p| p.split(',').map { |n| n.to_i } }
rules_map = {}
rules.each { |r| rules_map[r[0]] = rules_map[r[0]].nil? ? [r[1]] : rules_map[r[0]] << r[1] }

updates.each do |update|
  result += middle_element(update) if update_valid?(update, rules_map)
end

puts result