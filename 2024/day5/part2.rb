def middle_element(array)
  array[(array.length - 1) / 2]
end

# probs could consolidate checking to see if it's a bad update and fixing the update for faster code
def bad_update?(array, rules_map)
  array.each_with_index do |element, i|
    elements_that_must_appear_after = rules_map[element]
    next if elements_that_must_appear_after.nil?
    elements_that_must_appear_after.each do |number|
      next if !array.include?(number)
      (i + 1..array.length).each do |i2|
        break if array[i2] == number
        return true if array[i2].nil?
      end
    end
  end
  false
end

# update break to insert number before i2 if we find it
def fix_update(array, rules_map)
  fixed_array = []
  array.each_with_index do |element, i|
    elements_that_must_appear_after = rules_map[element]
    if elements_that_must_appear_after.nil? || fixed_array.empty?
      fixed_array << element
      next
    end
    (0..fixed_array.length).each do |i2|
      if fixed_array[i2] == nil
        fixed_array << element
      end
      if elements_that_must_appear_after.include?(fixed_array[i2])
        fixed_array.insert(i2, element)
        break
      end
    end
  end
  fixed_array
end

result = 0
input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
rules = input.split("\n\n")[0].split("\n").map { |r| r.split('|').map { |n| n.to_i } }
updates = input.split("\n\n")[1].split("\n").map { |p| p.split(',').map { |n| n.to_i } }
rules_map = {}
rules.each { |r| rules_map[r[0]] = rules_map[r[0]].nil? ? [r[1]] : rules_map[r[0]] << r[1] }

updates.each do |update|
  result += middle_element(fix_update(update, rules_map)) if bad_update?(update, rules_map)
end

puts result