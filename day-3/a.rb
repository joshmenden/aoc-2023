#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @grid = @data.split("\n").map {|l| l.split("") }
  end

  def numeric?(val)
    val.match?(/\A\d+\z/)
  end

  def within_bounds?(r,c)
    return false if r < 0
    return false if c < 0
    return false if r >= @grid.size
    return false if c >= @grid[0].size

    return true
  end

  def valid_engine?(digit, row_i, match_i)
    valid = false
    (match_i[0]..(match_i[1]-1)).each do |i|
      valid = true if within_bounds?(row_i, i - 1) && !numeric?(@grid[row_i][i - 1]) && @grid[row_i][i - 1] != "." # left
      valid = true if within_bounds?(row_i, i + 1) && !numeric?(@grid[row_i][i + 1]) && @grid[row_i][i + 1] != "." # right

      valid = true if within_bounds?(row_i - 1, i) && !numeric?(@grid[row_i - 1][i]) && @grid[row_i - 1][i] != "." # up
      valid = true if within_bounds?(row_i + 1, i) && !numeric?(@grid[row_i + 1][i]) && @grid[row_i + 1][i] != "." # down

      valid = true if within_bounds?(row_i - 1, i - 1) && !numeric?(@grid[row_i - 1][i - 1]) && @grid[row_i - 1][i - 1] != "." # up left
      valid = true if within_bounds?(row_i - 1, i + 1) && !numeric?(@grid[row_i - 1][i + 1]) && @grid[row_i - 1][i + 1] != "." # up right

      valid = true if within_bounds?(row_i + 1, i - 1) && !numeric?(@grid[row_i + 1][i - 1]) && @grid[row_i + 1][i - 1] != "." # down left
      valid = true if within_bounds?(row_i + 1, i + 1) && !numeric?(@grid[row_i + 1][i + 1]) && @grid[row_i + 1][i + 1] != "." # down right
    end

    valid
  end

  def pt1
    @sum = 0
    @data.split("\n").each_with_index do |row, row_i|
      matches = row.enum_for(:scan, /\d+/).map { |m| [m, $~.offset(0)] }

      matches.each do |d, match_i|
        @sum += d.to_i if valid_engine?(d, row_i, match_i)
      end
    end

    @sum
  end

  def pt2
  end
end

# filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
