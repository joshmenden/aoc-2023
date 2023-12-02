#!/usr/bin/env ruby

require "byebug"
require "active_support/all"

class Solution
    def initialize(filename, params)
      @data = File.read(filename)
      @params = params
      parse_data
    end

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

      puts valid.map {|v| v[:id] }.sum
    end

    def pt2
    end
end

filename = "input.txt"
# filename = "sample.txt"
puts Solution.new(filename, {}).pt1
puts Solution.new(filename, {}).pt2
