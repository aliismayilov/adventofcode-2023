class Map
  attr_reader :lines

  def initialize
    @lines = []
  end

  def add(line)
    return if line.strip == ""
    @lines << line.split.map(&:to_i)
  end

  def fetch(number)
    destination, source, range = lines.find do |destination, source, range|
      ((source)..(source + range)).cover?(number)
    end

    if range
      destination + number - source
    else
      number
    end
  end
end

if ENV["TEST"]
  def assert_equal(expected, actual)
    raise "expected=#{expected} actual=#{actual}" if expected != actual
  end

  -> do
    map = Map.new
    map.add("50 98 2")
    map.add("52 50 48")
    assert_equal(81, map.fetch(79))
    assert_equal(14, map.fetch(14))
    assert_equal(57, map.fetch(55))
    assert_equal(13, map.fetch(13))
    assert_equal(48, map.fetch(48))
    assert_equal(52, map.fetch(50))
    assert_equal(53, map.fetch(51))
    assert_equal(98, map.fetch(96))
    assert_equal(99, map.fetch(97))
    assert_equal(50, map.fetch(98))
    assert_equal(51, map.fetch(99))
  end.call

  puts "all green."
  exit
end

INPUT = File.read("test_input.txt")
seeds = []
seed_to_soil = nil
soil_to_fertilizer = nil
fertilizer_to_water = nil
water_to_light = nil
light_to_temperature = nil
temperature_to_humidity = nil
humidity_to_location = nil
current_map = nil

INPUT
  .lines
  .each do |line|
    if line.include?("seeds:")
      seed_parts = line.split(":").last.split.map(&:to_i)
      (0...seed_parts.size).each do |index|
        next if index.odd?
        seeds += (seed_parts[index]...(seed_parts[index] + seed_parts[index + 1])).to_a
      end
      next
    elsif line.include?("seed-to-soil")
      seed_to_soil = current_map = Map.new
      next
    elsif line.include?("soil-to-fertilizer")
      soil_to_fertilizer = current_map = Map.new
      next
    elsif line.include?("fertilizer-to-water")
      fertilizer_to_water = current_map = Map.new
      next
    elsif line.include?("water-to-light")
      water_to_light = current_map = Map.new
      next
    elsif line.include?("light-to-temperature")
      light_to_temperature = current_map = Map.new
      next
    elsif line.include?("temperature-to-humidity")
      temperature_to_humidity = current_map = Map.new
      next
    elsif line.include?("humidity-to-location")
      humidity_to_location = current_map = Map.new
      next
    end

    current_map&.add(line)
  end

result = seeds
  .map do |seed|
    seed_to_soil.fetch(seed)
  end
  .map do |seed|
    soil_to_fertilizer.fetch(seed)
  end
  .map do |seed|
    fertilizer_to_water.fetch(seed)
  end
  .map do |seed|
    water_to_light.fetch(seed)
  end
  .map do |seed|
    light_to_temperature.fetch(seed)
  end
  .map do |seed|
    temperature_to_humidity.fetch(seed)
  end
  .map do |seed|
    humidity_to_location.fetch(seed)
  end
  .min

puts "result #{result}"
