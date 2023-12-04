class Card
  attr_reader :winning_numbers, :numbers

  def initialize(string)
    winning_part, numbers_part = string.split("|")
    @winning_numbers = winning_part.split.map(&:to_i)
    @numbers = numbers_part.split.map(&:to_i)
  end

  def points
    count = winning_numbers.intersection(numbers).size
    return 0 if count == 0
    2 ** (count - 1)
  end
end

if ENV["TEST"]
  def assert_equal(expected, actual)
    raise "expected=#{expected} actual=#{actual}" if expected != actual
  end

  -> do
    card = Card.new("41 48 83 86 17 | 83 86  6 31 17  9 48 53")
    assert_equal([41, 48, 83, 86, 17], card.winning_numbers)
    assert_equal([83, 86, 6, 31, 17, 9, 48, 53], card.numbers)
    assert_equal(8, card.points)

    card = Card.new("31 18 13 56 72 | 74 77 10 23 35 67 36 11")
    assert_equal(0, card.points)
  end.call

  puts "all green."
  exit
end

INPUT = File.read("input.txt")

result = INPUT
  .lines
  .sum do |line|
    Card.new(line.split(":").last).points
  end

puts "result #{result}"
