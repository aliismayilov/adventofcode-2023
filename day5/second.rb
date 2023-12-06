class CustomRange
  attr_reader :destination, :source, :length

  def initialize(line)
    @destination, @source, @length = line.split.map(&:to_i)
  end

  def source_range
    source..(source + length)
  end

  def overlaps?(range)
    source_range.cover?(range.begin) ||
      source_range.cover?(range.end) ||
      (range.cover?(source_range.begin) && range.cover?(source_range.end))
  end

  def destination_range
    destination..(destination + length)
  end

  def fetch(number)
    destination + number - source
  end
end

class Map
  def initialize
    @ranges = []
  end

  def add(line)
    return if line.strip == ""
    @ranges << CustomRange.new(line)
  end

  def ranges
    @ranges.sort_by(&:source)
  end

  def fetch(number)
    ranges
      .find { |range| range.source_range.cover?(number) }
      .fetch(number)
  end

  def convert(seed_ranges)
    converted = []

    seed_ranges.each do |seed_range|
      overlapping_ranges = ranges.select { |r| r.overlaps?(seed_range) }

      if overlapping_ranges.none?
        converted << seed_range
        next
      end

      if !overlapping_ranges.first.source_range.cover?(seed_range.begin)
        converted << (seed_range.begin..(overlapping_ranges.first.source_range.begin - 1))
      end

      overlapping_ranges.each do |range|
        source_begin = [seed_range.begin, range.source_range.begin].max
        source_end = [seed_range.end, range.source_range.end].min

        converted << (range.fetch(source_begin)..range.fetch(source_end))
      end

      if !overlapping_ranges.last.source_range.cover?(seed_range.end)
        converted << ((overlapping_ranges.last.source_range.end + 1)..seed_range.end)
      end
    end

    converted
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

INPUT = File.read("input.txt")
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
        seeds << (seed_parts[index]..(seed_parts[index] + seed_parts[index + 1]))
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

result = humidity_to_location.convert(
  temperature_to_humidity.convert(
    light_to_temperature.convert(
      water_to_light.convert(
        fertilizer_to_water.convert(
          soil_to_fertilizer.convert(
            seed_to_soil.convert(
              seeds
            )
          )
        )
      )
    )
  )
)

puts "result #{result.map(&:begin).min}"
