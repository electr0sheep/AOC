# With ruby arrays, array[-1] is the last element, [-2] is second to last and so on. We don't want wrappping.
module PositiveIndexing
  def [](index)
    raise IndexError, "Negative indexes are not allowed" if index < 0
    super(index)
  end
end

def find_all_matches(row_index, column_index)
  (-1..1).each do |y_direction|
    (-1..1).each do |x_direction|
      $result += 1 if match?(row_index, column_index, y_direction, x_direction)
    end
  end
end

def match?(row_index, column_index, y_direction, x_direction)
  letters = ['X', 'M', 'A', 'S']
  (0..3).each do |iteration|
    begin
      letter = $input_array[row_index + y_direction * iteration][column_index + x_direction * iteration]
    rescue NoMethodError, IndexError
      return false
    end
    return false if letter != letters[iteration]
  end
  return true
end

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
$result = 0

$input_array = input.split("\n").map { |l| l.split('') }
$input_array.extend PositiveIndexing
$input_array.each { |a| a.extend PositiveIndexing }

(0..$input_array.length - 1).each do |row_index|
  row = $input_array[row_index]
  (0..row.length - 1).each do |column_index|
    letter = row[column_index]
    find_all_matches(row_index, column_index) if letter == 'X'
  end
end

puts $result