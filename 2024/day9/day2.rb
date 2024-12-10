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

def calculate_free_space(array, index)
  size = 0
  while array[index].nil?
    index += 1
    size += 1
  end

  size
end

def number_of_files(array, index)
  file_id = array[index]
  size = 0
  until array[index] != file_id
    index -= 1
    size += 1
  end

  size
end

def remove_gaps(array)
  left_index = 0
  right_index = array.length - 1
  while right_index.positive?
    left_index += 1 unless array[left_index].nil?
    right_index -= 1 if array[right_index].nil?
    if left_index > right_index
      left_index = 0
      right_index -= number_of_files(array, right_index)
    end

    next unless array[left_index].nil? && !array[right_index].nil?

    free_space = calculate_free_space(array, left_index)
    if free_space < number_of_files(array, right_index)
      left_index += free_space
    else
      current_file = array[right_index]
      # first attempt I assumed that a file would eventually end with a nil, even after swap.
      # everything worked great, except the swaps could cause the number to continue. See 12101 for example
      (0..number_of_files(array, right_index) - 1).each do |i|
        array[left_index + i] = current_file
        array[right_index - i] = nil
      end
      right_index -= number_of_files(array, right_index)
      left_index = 0
    end
  end
  array
end

def checksum(array)
  result = 0
  (0..array.length - 1).each do |i|
    result += array[i].to_i * i
  end

  result
end

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))

raw_array = get_raw_array(input)
shuffled_array = remove_gaps(raw_array.dup)
puts checksum(shuffled_array)
