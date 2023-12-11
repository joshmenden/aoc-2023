#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

# the trick for this one is manhattan geometry
# https://en.wikipedia.org/wiki/Taxicab_geometry

class Day < AOCSolution
  def parse_data
    @cosmos = twod_arr(@data)
    @column_expansion_indices = @cosmos.transpose.each_with_index.select { |r, _| r.all? { |val| val == "." } }.map(&:last).sort.reverse
    @row_expansion_indices = @cosmos.each_with_index.select { |r, _| r.all? { |v| v == "." } }.map(&:last)
  end

  def shortest_path(expansion_factor, (a, b))
    row_dist = (b[0] - a[0]).abs + expand(expansion_factor, @row_expansion_indices, b[0], a[0])
    column_dist = (b[1] - a[1]).abs + expand(expansion_factor, @column_expansion_indices, b[1], a[1])

    row_dist + column_dist
  end

  def expand(expansion_factor, indices, c1, c2)
    sorted = [c1, c2].sort
    (expansion_factor - 1) * (indices.count { |num| (sorted[0]..sorted[1]).include?(num) })
  end

  def pt1(expansion_factor: 2)
    @cosmos
      .each_with_index
      .flat_map { |r, rind| r.each_with_index.map { |val, cind| [rind, cind] if val == "#" } }
      .compact
      .combination(2)
      .to_a
      .reduce(0) { |acc, combo| acc + shortest_path(expansion_factor, combo) }
  end

  def pt2
    pt1(expansion_factor: 1_000_000)
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
