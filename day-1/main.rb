#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require 'io/console'                                                                                                       

content = File.read("input.txt")

digits = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

total = 0
file_data = ""

content.split("\n").each do |line|
  replaced = line
  digits.each_with_index { |num, i| replaced = replaced.gsub(num, num + i.to_s + num) }
  d = replaced.scan(/\d/)
  total += (d[0] + d[d.length - 1]).to_i
end

puts total
