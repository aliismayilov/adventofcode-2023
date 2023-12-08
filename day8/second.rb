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

    counters = []
    current_keys = map.keys.select { |key| key.end_with?("A") }

    while (current_keys.any?) do
      direction = route[counter % route.size] == "L" ? 0 : 1
      current_keys = current_keys.map do |current_key|
        map[current_key][direction]
      end
      counter += 1
      current_keys = current_keys.reject do |key|
        if result = key.end_with?("Z")
          counters << counter
        end

        result
      end
    end

    counters.reduce(1, :lcm)
  end
end

pp Camel.new(INPUT).traverse
