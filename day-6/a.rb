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
    # brute force ~3.3s to solve
    # calculate_wins(@data.scan(/\w+:\s+(\d+(?:\s+\d+)*)/)
    #         .flatten
    #         .map {|str| str.gsub(" ", "")}
    #         .map(&:to_i))

    # quadratic formula: ax^2 + bx + c = 0
    t, d = @data.scan(/\w+:\s+(\d+(?:\s+\d+)*)/)
                .flatten
                .map {|str| str.gsub(" ", "")}
                .map(&:to_i)

    # record = held * (time - held)
    # record = (held*time) - (held^2)
    # 0 = -held^2 + (time*held) - record
    # for me, held is x
    # x = [-b ± sqrt(b^2 - 4ac)] / (2a)
    held1 = (-t + Math.sqrt(t ** 2 - 4 * d)) / -2
    held2 = (-t - Math.sqrt(t ** 2 - 4 * d)) / -2
    held2.floor - held1.ceil + 1
  end
end

filename = "input.txt"
# filename = "sample.txt"
Day.new(filename).solve!
