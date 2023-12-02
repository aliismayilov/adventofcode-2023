require "bundler/setup"
require "tldr"

class Hand
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
end

class Game
  attr_reader :id, :hands, :minimums

  def initialize(line)
    _id_part, hands_part = line.split(":")
    @hands = hands_part.split(";").map do |string|
      Hand.new(string)
    end
  end

  def max_shown(color)
    @hands.map do |hand|
      hand.public_send(color)
    end.max
  end

  def power
    max_shown(:red) * max_shown(:green) * max_shown(:blue)
  end
end

class Test < TLDR
  def test_good_game
    game = Game.new("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
    assert_equal game.max_shown(:red), 4
    assert_equal game.max_shown(:green), 2
    assert_equal game.max_shown(:blue), 6
    assert_equal game.power, 48
  end
end

result = File.read("input.txt")
  .lines
  .map do |line|
    Game.new(line)
  end
  .sum(&:power)

puts "result => #{result}"
