INPUT = File.read("input.txt")

TYPES = %i[
  high_card
  one_pair
  two_pair
  three_of_a_kind
  full_house
  four_of_a_kind
  five_of_a_kind
]

CARDS = %w[2 3 4 5 6 7 8 9 T J Q K A]

class Hand
  include Comparable

  attr_reader :cards, :bid

  def initialize(string)
    cards_part, bid_part = string.split
    @cards = cards_part.chars
    @bid = bid_part.to_i
  end

  def inspect
    cards.join
  end

  def tally
    @_tally ||= cards.tally
  end

  def type
    return :five_of_a_kind if tally.keys.size == 1
    return :four_of_a_kind if tally.values.include?(4)
    return :full_house if tally.values.sort == [2, 3]
    return :three_of_a_kind if tally.values.include?(3)
    return :two_pair if tally.values.sort == [1, 2, 2]
    return :one_pair if tally.values.include?(2)

    :high_card
  end

  def <=>(other)
    if type != other.type
      return TYPES.index(type) <=> TYPES.index(other.type)
    end

    cards.each_with_index do |card, index|
      if card != other.cards[index]
        return CARDS.index(card) <=> CARDS.index(other.cards[index])
      end
    end

    0
  end
end

if ENV["TEST"]
  def assert_equal(actual, expected)
    raise "expected=#{expected} actual=#{actual}" if expected != actual
  end

  -> do
    hand1 = Hand.new("32T3K 765")
    assert_equal(hand1.type, :one_pair)
    hand2 = Hand.new("T55J5 684")
    assert_equal(hand2.type, :three_of_a_kind)
    hand3 = Hand.new("KK677 28")
    assert_equal(hand3.type, :two_pair)
    hand4 = Hand.new("KTJJT 220")
    assert_equal(hand4.type, :two_pair)
    hand5 = Hand.new("QQQJA 483")
    assert_equal(hand5.type, :three_of_a_kind)
    assert_equal([hand1, hand2, hand3, hand4, hand5].sort, [hand1, hand4, hand3, hand2, hand5])
  end.call

  puts "all green."
  exit
end

rank = 0
result = INPUT.lines
  .map do |line|
    Hand.new(line)
  end
  .sort
  .inject(0) do |acc, hand|
    rank += 1
    acc += hand.bid * rank
  end

pp "result #{result}"
