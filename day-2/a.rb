#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @games = @data.split("\n").map do |l|
      id = l.split(":")[0].split(" ")[1].to_i
      sets = l.split(":")[1].split("; ").map(&:strip)
      sets = sets.map do |set|
        draws = set.split(",").map(&:strip)
        s = Hash.new
        draws.each do |d|
          num, color = d.split(" ")
          s[color] = num.to_i
        end

        s
      end

      {
        id: id,
        sets: sets
      }
    end
  end

  def pt1
    # only 12 red cubes, 13 green cubes, and 14 blue cubes
    valid = @games.select do |g|
      g[:sets].all? do |set|
        (set["red"].nil? || set["red"] <= 12) && (set["green"].nil? || set["green"] <= 13) && (set["blue"].nil? || set["blue"] <= 14)
      end
    end

    valid.map {|v| v[:id] }.sum
  end

  def pt2
    powers = @games.map do |game|
      min_red = game[:sets].map {|s| s["red"]}.compact.max
      min_blue = game[:sets].map {|s| s["blue"]}.compact.max
      min_green = game[:sets].map {|s| s["green"]}.compact.max

      min_red * min_blue * min_green
    end

    powers.sum
  end
end

filename = "sample.txt"
# filename = "input.txt"
Day.new(filename).solve!
