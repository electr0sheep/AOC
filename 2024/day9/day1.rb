# frozen_string_literal: true

def get_raw_array(string)
  return_array = []
  file = false
  id = -1

  string.chars do |char|
    file = !file
    if file
      id += 1
      char.to_i.times do
        return_array << id.to_s
      end
    else
      char.to_i.times do
        return_array << nil
      end
    end
  end

  return_array
end

def remove_gaps(array)
  left_index = 0
  right_index = array.length - 1
  while left_index < right_index
    if array[left_index].nil? && !array[right_index].nil?
      array[left_index] = array[right_index]
      array[right_index] = nil
    end
    left_index += 1 unless array[left_index].nil?
    right_index -= 1 if array[right_index].nil?
  end
  array
end

def checksum(array)
  result = 0
  (0..array.length - 1).each do |i|
    return result if array[i].nil?

    result += array[i].to_i * i
  end

  result
end

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))

raw_array = get_raw_array(input)
shuffled_array = remove_gaps(raw_array.dup)
puts checksum(shuffled_array)
