input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
list1 = []
list2 = []
similarity_scores = []
lines = input.split("\n")
lines.each do |line|
  list1 << line.split('   ')[0].to_i
  list2 << line.split('   ')[1].to_i
end

# if the lists are sorted, we can find the matches quicker and calculate answers more quickly
# good thing that's not even remotely necessary for what we're doing here.
# list1.sort!
# list2.sort!

# we could potentially just make a map out of list2 as well with something like {1: 0, 2: 4, 3: 2, 4: 1} so
# we don't even have to search. screw that noise though.

list1.each do |num1|
  occurences = 0
  list2.each do |num2|
    occurences += 1 if num1 == num2
  end
  similarity_scores << num1 * occurences
end

puts similarity_scores.sum