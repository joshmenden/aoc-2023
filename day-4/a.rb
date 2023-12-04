#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def pt1
    @data.scan(/(.*): (.*) \| (.*)/).map { |match| (match[1].split & match[2].split).length }.reduce(0) { |acc, winners| winners == 0 ? acc : acc + 2**(winners - 1) }
  end

  def pt2
    games = {}
    data = @data.scan(/(.*): (.*) \| (.*)/).each do |match|
      games[match[0].split.last.to_i] = { copies: 1, winners: (match[1].split & match[2].split).length }
    end

    games.keys.each do |k|
      games[k][:copies].times do
        games[k][:winners].times do |i|
          games[k + i + 1][:copies] += 1 unless games[k + i + 1].nil?
        end
      end
    end

   games.values.map {|v| v[:copies]}.sum
  end
end

# filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
