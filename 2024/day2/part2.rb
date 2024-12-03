def remove_index(array, index)
  array[0, index].concat(array[index + 1..-1])
end

def report_safe?(report)
  going_up = (report[0] - report[1]).negative?
  (1..report.length - 1).each_with_index do |n|
    previous_number = report[n - 1]
    current_number = report[n]
    difference = previous_number - current_number
    if difference.abs < 1 || difference.abs > 3
      (0..report.length - 1).each do |n2|
        return true if report_safe_after_removal?(remove_index(report, n2))
      end
      return false
    end
    if difference.positive? && going_up
      (0..report.length - 1).each do |n2|
        return true if report_safe_after_removal?(remove_index(report, n2))
      end
      return false
    end
    if difference.negative? && !going_up
      (0..report.length - 1).each do |n2|
        return true if report_safe_after_removal?(remove_index(report, n2))
      end
      return false
    end
  end
  return true
end

def report_safe_after_removal?(report)
  going_up = (report[0] - report[1]).negative?
  (1..report.length - 1).each_with_index do |n, i|
    previous_number = report[n - 1]
    current_number = report[n]
    difference = previous_number - current_number
    return false if difference.abs < 1 || difference.abs > 3
    return false if difference.positive? && going_up
    return false if difference.negative? && !going_up
  end
  return true
end

input = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
reports = input.split("\n").map { |r| r.split(' ').map { |n| n.to_i } }
safe_reports = 0

reports.each do |report|
  safe_reports += 1 if report_safe?(report)
end

puts safe_reports