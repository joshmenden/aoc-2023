#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
content = File.read("example.txt")
# content = File.read("input.txt")

total = 0

content.split("\n").each do |line|
  digits = line.gsub(/[^0-9]/, '') 
  first = digits[0]
  last = digits[digits.length - 1]
  total += (first + last).to_i
end

puts total

# single = content.split("\n").first
# single = single.gsub(/[^0-9]/, '')
# puts single
# puts single[0]

# puts (single[0] + single[single.length - 1]).to_i

# puts content
