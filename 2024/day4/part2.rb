# With ruby arrays, array[-1] is the last element, [-2] is second to last and so on. We don't want wrappping.
module PositiveIndexing
  def [](index)
    raise IndexError, "Negative indexes are not allowed" if index < 0
    super(index)
  end
end

def x_marks_the_spot?(row_index, column_index)
  return false if $input_array[row_index][column_index] != 'A'

  # check diagonal
  # M..
  # .A.
  # ..S
  if $input_array[row_index - 1][column_index - 1] == 'M'
    return false if $input_array[row_index + 1][column_index + 1] != 'S'
  elsif $input_array[row_index - 1][column_index - 1] == 'S'
    return false if $input_array[row_index + 1][column_index + 1] != 'M'
  else
    return false
  end

  # check diagonal
  # ..M
  # .A.
  # S..
  if $input_array[row_index - 1][column_index + 1] == 'M'
    return false if $input_array[row_index + 1][column_index - 1] != 'S'
  elsif $input_array[row_index - 1][column_index + 1] == 'S'
    return false if $input_array[row_index + 1][column_index - 1] != 'M'
  else
    return false
  end

  return true
rescue NoMethodError, IndexError
  return false
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
    $result += 1 if letter == 'A' && x_marks_the_spot?(row_index, column_index)
  end
end

puts $result