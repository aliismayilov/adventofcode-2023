require "bundler/setup"
require "tldr"

class Hand
  MAX_HAND = {
    red: 12,
    green: 13,
    blue: 14
  }

  def initialize(string)
    @string = string
  end

  def red = extract(:red)

  def green = extract(:green)

  def blue = extract(:blue)

  def extract(color)
    @string.split(",").find do |part|
      part.include?(color.to_s)
    end&.split&.first.to_i
  end

  def possible?
    MAX_HAND.all? do |color, max_amount|
      public_send(color) <= max_amount
    end
  end
end

class Game
  attr_reader :id, :hands

  def initialize(line)
    id_part, hands_part = line.split(":")
    @id = id_part.split.last.to_i
    @hands = hands_part.split(";").map do |string|
      Hand.new(string)
    end
  end

  def possible?
    hands.all?(&:possible?)
  end
end

class TestFirst < TLDR
  def test_good_game
    game = Game.new("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
    assert_equal game.id, 1
    assert game.possible?
  end

  def test_bad_game
    game = Game.new("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red")
    assert_equal game.id, 3
    refute game.possible?
  end

  def test_good_hand
    hand = Hand.new("3 blue, 4 red")
    assert_equal hand.red, 4
    assert_equal hand.green, 0
    assert_equal hand.blue, 3
    assert hand.possible?
  end

  def test_bad_hand
    hand = Hand.new(" 8 green, 6 blue, 20 red")
    assert_equal hand.red, 20
    assert_equal hand.green, 8
    assert_equal hand.blue, 6
    refute hand.possible?
  end
end

result = File.read(ARGV[0] || "test_input.txt")
  .lines
  .map do |line|
    Game.new(line)
  end
  .select(&:possible?)
  .sum(&:id)

puts "result => #{result}"
