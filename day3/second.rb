class Number
  attr_reader :value, :start_pos

  def initialize(value, start_pos)
    @value = value
    @start_pos = start_pos
  end

  def end_pos
    [end_x, y]
  end

  def y = start_pos[1]
  def start_x = start_pos[0]
  def end_x = start_x + value.to_s.chars.size - 1

  def adjacent?(pos)
    pos_x, pos_y = pos

    return false if (pos_y - y).abs > 1

    ((start_x - 1)..(end_x + 1)).cover?(pos_x)
  end
end

if ENV["TEST"]
  def assert_equal(expected, actual)
    raise "expected=#{expected} actual=#{actual}" if expected != actual
  end

  -> do
    number = Number.new(1, [0, 0])
    assert_equal([0, 0], number.end_pos)
    assert_equal(true, number.adjacent?([0, 1]))

    number = Number.new(123, [0, 0])
    assert_equal([2, 0], number.end_pos)
    assert_equal(true, number.adjacent?([1, 0]))
    assert_equal(true, number.adjacent?([3, 1]))
    assert_equal(false, number.adjacent?([1, 4]))

    number = Number.new(35, [2, 2])
    assert_equal([3, 2], number.end_pos)
    assert_equal(true, number.adjacent?([3, 1]))
  end.call

  puts "all green."
  exit
end

gear_candidates = []
numbers = []

INPUT = File.read(ARGV[0])

INPUT.lines.each_with_index do |line, y|
  start_pos = nil
  number = nil

  line.chars.each_with_index do |char, x|
    next if char == "\n"

    if char.match?(/[[:digit:]]/)
      start_pos ||= [x, y]

      if number.nil?
        number = char
      else
        number << char
      end
    else
      if char == "*"
        gear_candidates << [x, y]
      end

      if number
        numbers << Number.new(number.to_i, start_pos)
      end

      start_pos = nil
      number = nil
    end
  end
end

result = gear_candidates
  .map do |gear_candidate|
    [
      gear_candidate,
      numbers.select { |n| n.adjacent?(gear_candidate) }
    ]
  end
  .select do |gear_candidate, numbers|
    numbers.size == 2
  end
  .sum do |gear_pos, numbers|
    numbers[0].value * numbers[1].value
  end

puts "result #{result}"
