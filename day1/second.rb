input = <<~EOL
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
EOL

WORD_DIGITS = [
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine"
]

DIGITS = [
  1,2,3,4,5,6,7,8,9
]

def extract_from_string(string)
  find_digit = ->(digit) { string.include?(digit.to_s) }

  result = DIGITS.index(&find_digit) || WORD_DIGITS.index(&find_digit)

  return if result.nil?

  result + 1
end

def extract_from_end_of_line(line)
  start = line.length - 1
  finish = line.length

  while (!(value = extract_from_string(line[start...finish]))) do
    start -= 1

    break if start < 0
  end

  value
end

def extract_from_beginning_of_line(line)
  start = 0
  finish = 1

  while (!(value = extract_from_string(line[start...finish]))) do
    finish += 1

    break if finish > line.length
  end

  value
end

def extract_value(line)
  first_digit = extract_from_beginning_of_line(line)
  last_digit = extract_from_end_of_line(line)

  result = [first_digit, last_digit].join("").to_i

  puts "#{line} => #{result}"

  result
end

input.split.sum do |line|
  extract_value(line)
end
