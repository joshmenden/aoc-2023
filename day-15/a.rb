#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def pt1
    @data.split(",").reduce(0) do |acc, seq|
      acc + seq.each_char.reject { |char| char == "\n" }.reduce(0) do |curr, char|
        ((curr + char.ord) * 17) % 256
      end
    end
  end

  def pt2
  end
end

filename = "hash.txt"
filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
