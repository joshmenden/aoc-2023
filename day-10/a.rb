#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @data = twod_arr(@data)
    @loop = []
    @connections = {
      "S": {
        north: ["|", "F", "7"],
        south: ["|", "L", "J"],
        west: ["-", "L", "F"],
        east: ["-", "J", "7"],
      },
      "-": {
        east: ["-", "J", "7"],
        west: ["-", "L", "F"]
      },
      "|": {
        north: ["|", "F", "7"],
        south: ["|", "L", "J"]
      },
      "L": {
        north: ["|", "F", "7"],
        east: ["-", "J", "7"],
      },
      "J": {
        north: ["|", "F", "7"],
        west: ["-", "L", "F"],
      },
      "7": {
        south: ["|", "L", "J"],
        west: ["-", "L", "F"],
      },
      "F": {
        south: ["|", "L", "J"],
        east: ["-", "J", "7"],
      },
    }.with_indifferent_access
  end

  def pt1
    start = @data.each_with_index {|arr, i| j = arr.index("S"); break [i,j] if j }
    bfs(start).length / 2
  end

  def add?(curr, cand, dir)
    r1, c1 = curr
    r2, c2 = cand

    # require "byebug"; byebug;
    !@loop.include?(cand) && within_bounds?(@data, r2, c2) && pipes_connect?(@data[r1][c1], @data[r2][c2], dir)
  end

  def pipes_connect?(a, b, dir)
    return false unless @connections[a].key?(dir)
    return @connections[a][dir].include?(b)
  end

  def bfs(start)
    queue = [start]

    while !queue.empty?
      r, c = queue.pop
      @loop << [r, c]

      [
        [r, c + 1, :east],
        [r, c - 1, :west],
        [r + 1, c, :south],
        [r - 1, c, :north],
      ].each do |cand_r, cand_c, dir|
        queue << [cand_r, cand_c] if add?([r,c], [cand_r, cand_c], dir)
      end
    end

    @loop
  end

  def pt2
  end
end

filename = "sample.txt"
filename = "sample2.txt"
filename = "input.txt"
Day.new(filename).solve!
