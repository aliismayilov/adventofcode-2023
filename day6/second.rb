INPUT = File.read("input.txt")

class Race
  attr_reader :max_time, :min_distance

  def initialize(max_time, min_distance)
    @max_time, @min_distance = max_time, min_distance
  end

  def possibilities
    start = nil
    finish = nil

    1.upto(max_time).each do |time|
      time_left = max_time - time
      distance = time_left * time

      if start.nil? && distance > min_distance
        start = time
      end

      if start && distance <= min_distance
        finish = time - 1
        break
      end
    end

    start..finish
  end
end

if ENV["TEST"]
  def assert_equal(actual, expected)
    raise "expected=#{expected} actual=#{actual}" if expected != actual
  end

  -> do
    assert_equal(Race.new(7, 9).possibilities, 2..5)
    assert_equal(Race.new(15, 40).possibilities, 4..11)
    assert_equal(Race.new(30, 200).possibilities, 11..19)
  end.call

  puts "all green."
  exit
end

time = nil
distance = nil
INPUT.lines.each do |line|
  if line.start_with?("Time")
    _, time_part = line.split(":")
    time = time_part.tr(" ", "").to_i
  elsif line.start_with?("Distance")
    _, distance_part = line.split(":")
    distance = distance_part.tr(" ", "").to_i
  end
end

pp "result #{Race.new(time, distance).possibilities.size}"
