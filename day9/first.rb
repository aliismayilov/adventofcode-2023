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
end

if ENV["TEST"]
  def assert_equal(actual, expected)
    raise "expected=#{expected} actual=#{actual}" if expected != actual
  end

  -> do
    line = Line.new([0, 3, 6, 9, 12, 15])
    next_line = line.next
    assert_equal(next_line.numbers, [3, 3, 3, 3, 3])
    next_line = next_line.next
    assert_equal(next_line.numbers, [0, 0, 0, 0])
    assert_equal(next_line.zeroes?, true)

    history = History.new("1 3 6 10 15 21")
    assert_equal(history.lines.map(&:numbers), [
      [1, 3, 6, 10, 15, 21],
      [2, 3, 4, 5, 6],
      [1, 1, 1, 1],
      [0, 0, 0]
    ])
    assert_equal(history.next_number, 28)

    assert_equal(History.new("0 3 6 9 12 15").next_number, 18)
    assert_equal(History.new("10 13 16 21 30 45").next_number, 68)
  end.call

  puts "all green."
  exit
end

result = INPUT.lines
  .sum do |line|
    History.new(line).next_number
  end

pp "result = #{result}"
