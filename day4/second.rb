class Card
  attr_reader :id, :winning_numbers, :numbers

  def initialize(string)
    id_part, rest = string.split(":")
    @id = id_part.split.last.to_i
    winning_part, numbers_part = rest.split("|")
    @winning_numbers = winning_part.split.map(&:to_i)
    @numbers = numbers_part.split.map(&:to_i)
  end

  def matches
    winning_numbers.intersection(numbers).size
  end
end

if ENV["TEST"]
  def assert_equal(expected, actual)
    raise "expected=#{expected} actual=#{actual}" if expected != actual
  end

  -> do
    card = Card.new("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
    assert_equal([41, 48, 83, 86, 17], card.winning_numbers)
    assert_equal([83, 86, 6, 31, 17, 9, 48, 53], card.numbers)
    assert_equal(1, card.id)
    assert_equal(4, card.matches)

    card = Card.new("Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11")
    assert_equal(6, card.id)
    assert_equal(0, card.matches)
  end.call

  puts "all green."
  exit
end

INPUT = File.read("input.txt")

counter = Hash.new(0)

INPUT
  .lines
  .each do |line|
    card = Card.new(line)

    counter[card.id] += 1

    counter[card.id].times do
      ((card.id + 1)..(card.id + card.matches)).each do |id|
        counter[id] += 1
      end
    end
  end

puts "result #{counter.values.sum}"
