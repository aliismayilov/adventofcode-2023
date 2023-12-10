# frozen_string_literal: true

INPUT = File.read("input.txt")

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def north = Point.new(x, y - 1)
  def east = Point.new(x + 1, y)
  def south = Point.new(x, y + 1)
  def west = Point.new(x - 1, y)

  def ==(other)
    x == other.x && y == other.y
  end
end

class Map
  attr_reader :matrix, :start

  def initialize(string)
    @matrix = []
    string.lines.each_with_index do |line, index|
      if (col = line.index("S"))
        @start = Point.new(col, index)
      end

      @matrix << line.strip.chars
    end
  end

  def traverse
    step = 1
    current_tiles = []

    # go north
    point = start.north
    if inside?(point)
      current_tiles << Tile.new(from: "S", shape: matrix[point.y][point.x], point:)
    end

    # go east
    point = start.east
    if inside?(point)
      current_tiles << Tile.new(from: "W", shape: matrix[point.y][point.x], point:)
    end

    # go south
    point = start.south
    if inside?(point)
      current_tiles << Tile.new(from: "N", shape: matrix[point.y][point.x], point:)
    end

    while (current_tiles.none? { |tile| tile.point == start }) do
      current_tiles = current_tiles.map do |current_tile|
        point = current_tile.to
        next if point.nil?
        next unless inside?(point)

        Tile.new(from: current_tile.opposite_direction, shape: matrix[point.y][point.x], point:)
      end.compact

      step += 1
    end

    step.fdiv(2).ceil
  end

  def inside?(point)
    point.x.between?(0, matrix.first.size - 1) &&
      point.y.between?(0, matrix.size - 1)
  end
end

class Tile
  attr_reader :from, :shape, :point

  def initialize(from:, shape:, point:)
    @from, @shape, @point = from, shape, point
  end

  def to
    {
      "N" => point.north,
      "E" => point.east,
      "S" => point.south,
      "W" => point.west,
    }[direction]
  end

  def direction
    {
      ["N", "L"] => "E",
      ["N", "|"] => "S",
      ["N", "J"] => "W",
      ["E", "F"] => "S",
      ["E", "-"] => "W",
      ["E", "L"] => "N",
      ["S", "7"] => "W",
      ["S", "|"] => "N",
      ["S", "F"] => "E",
      ["W", "J"] => "N",
      ["W", "-"] => "E",
      ["W", "7"] => "S"
    }[[from, shape]]
  end

  def opposite_direction
    {
      "N" => "S",
      "E" => "W",
      "S" => "N",
      "W" => "E"
    }[direction]
  end
end

pp "result #{Map.new(INPUT).traverse}"
