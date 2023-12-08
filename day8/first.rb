INPUT = File.read("input.txt")

class Camel
  attr_reader :route, :map

  def initialize(input)
    @map = {}
    input.lines.each_with_index do |line, index|
      if index == 0
        @route = line.strip.chars
        next
      end

      next if line.strip.empty?

      key, values = line.split(" = ").map(&:strip)
      @map[key] = values.tr("()", "").split(", ")
    end
  end

  def traverse
    counter = 0

    current_key = "AAA"

    while (current_key != "ZZZ") do
      direction = route[counter % route.size] == "L" ? 0 : 1
      current_key = map[current_key][direction]
      counter += 1
    end

    counter
  end
end

pp Camel.new(INPUT).traverse
