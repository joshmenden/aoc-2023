#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @grid = @data.split("\n").map {|l| l.split("") }
    @original_grid = @data.split("\n").map {|l| l.split("") }
    @islands = []
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

  def sum_island(island)
    rows_hash = island.group_by {|r,c| r}.transform_values {|v| v.sort }
    units = []

    rows_hash.each do |k, v|
      unit = []
      counter = nil
      v.each_with_index do |coords,i|
        r,c = coords
        if counter.nil?
          unit << [r,c]
          counter = c
        elsif counter == c - 1
          unit << [r,c]
          counter = c
        else
          units << unit
          unit = [[r,c]]
          counter = c
        end

        if i == v.length - 1
          units << unit
        end
      end
    end

    units = units.map {|u| u.map {|r,c| @original_grid[r][c] }}

    engine_nums = units.map(&:join).map do |val|
      numeric?(val) ? val : val.split(/\D/).reject(&:empty?)
    end.flatten.map(&:to_i)

    engine_nums
  end

  def bfs(row, column)
    queue = [[row, column]]
    island = []

    while !queue.empty?
      r, c = queue.pop
      if @grid[r][c] != "."

        island << [r, c]

        @grid[r][c] = "."

        queue << [r + 1, c] if (r + 1 < @grid.size && @grid[r + 1][c] != ".") # down
        queue << [r - 1, c] if (r - 1 >= 0 && @grid[r - 1][c] != ".") # up

        queue << [r, c + 1] if (c + 1 < @grid[0].size && @grid[r][c + 1] != ".") # right
        queue << [r, c - 1] if (c - 1 >= 0 && @grid[r][c - 1] != ".") # left

        queue << [r + 1, c + 1] if (r + 1 < @grid.size && c + 1 < @grid[0].size && @grid[r + 1][c + 1] != ".") # down-right
        queue << [r + 1, c - 1] if (r + 1 < @grid.size && c - 1 >= 0 && @grid[r + 1][c - 1] != ".") # down-left

        queue << [r - 1, c + 1] if (r - 1 >= 0 && c + 1 < @grid[0].size && @grid[r - 1][c + 1] != ".") # up-right
        queue << [r - 1, c - 1] if (r - 1 >= 0 && c -1 >= 0 && @grid[r - 1][c - 1] != ".") # up-left
      end
    end

    island
  end

  def pt2
    @grid.each_with_index do |row, r|
      row.each_with_index do |val, c|
        next if val == "."

        @islands.push(bfs(r, c))
      end
    end

    @islands.reject! do |isl|
      isl.all? do |r, c|
        numeric?(@original_grid[r][c])
      end
    end

    e = @islands.map {|i| sum_island(i) }
    e.reject {|e| e.length != 2 }.map {|a,b| a*b }.sum
  end
end

# filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
