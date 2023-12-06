#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def calculate_wins(race)
    t, d = race
    t.times.reduce(0) { |n, ms| ((t - ms) * ms > d) ? n + 1 : n + 0 }
  end

  def pt1
    @data.scan(/\w+:\s+(\d+(?:\s+\d+)*)/)
      .flatten
      .map(&:split)
      .map {|arr| arr.map(&:to_i)}
      .transpose
      .reduce(1) { |n, race| n * calculate_wins(race) }
  end

  def pt2
    calculate_wins(@data.scan(/\w+:\s+(\d+(?:\s+\d+)*)/)
      .flatten
      .map {|str| str.gsub(" ", "")}
      .map(&:to_i))
  end
end

filename = "input.txt"
filename = "sample.txt"
Day.new(filename).solve!
