input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
list1 = []
list2 = []
distances = []
lines = input.split("\n")
lines.each do |line|
  list1 << line.split('   ')[0].to_i
  list2 << line.split('   ')[1].to_i
end

list1.sort!
list2.sort!

(0..list1.length - 1).each do |n|
  distances << (list1[n] - list2[n]).abs
end

puts distances.sum