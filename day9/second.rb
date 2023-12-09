INPUT = File.read("input.txt")

class Line
  attr_reader :numbers

  def initialize(numbers)
    @numbers = numbers
  end

  def next
    next_numbers = 0.upto(numbers.size - 2).map do |index|
      numbers[index + 1] - numbers[index]
    end

    Line.new(next_numbers)
  end

  def zeroes?
    numbers.uniq == [0]
  end
end

class History
  attr_reader :lines

  def initialize(string)
    @lines = []
    @lines << Line.new(string.split.map(&:to_i))
    generate_lines
  end

  def generate_lines
    while (!lines.last.zeroes?) do
      lines << lines.last.next
    end
  end

  def next_number
    lines.reverse.inject(nil) do |acc, line|
      acc ||= line.numbers.last
      acc + line.numbers.last
    end
  end

  def previous_number
    lines.reverse.inject(nil) do |acc, line|
      acc ||= line.numbers.first
      line.numbers.first - acc
    end
  end
end

if ENV["TEST"]
  def assert_equal(actual, expected)
    raise "expected=#{expected} actual=#{actual}" if expected != actual
  end

  -> do
    assert_equal(History.new("10 13 16 21 30 45").previous_number, 5)
  end.call

  puts "all green."
  exit
end

result = INPUT.lines
  .sum do |line|
    History.new(line).previous_number
  end

pp "result = #{result}"
