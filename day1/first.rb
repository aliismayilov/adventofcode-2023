input = <<~EOL
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
EOL

def extract_value(line)
  digits = line.scan(/\d/)
  first_digit = digits.first
  last_digit = digits.last

  [first_digit, last_digit].join("").to_i
end

input.split.sum do |line|
  extract_value(line)
end
