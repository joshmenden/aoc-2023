#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @data = twod_arr(@data)
    @reflections = {
      ".": ->(dir, row, col) {
        case dir
        when :left
          return [[row, col - 1, :left]]
        when :right
          return [[row, col + 1, :right]]
        when :up
          return [[row - 1, col, :up]]
        when :down
          return [[row + 1, col, :down]]
        end
      },
      "|": ->(dir, row, col) {
        case dir
        when :left, :right
          return [[row - 1, col, :up], [row + 1, col, :down]]
        when :up
          return [[row - 1, col, :up]]
        when :down
          return [[row + 1, col, :down]]
        end
      },
      "-": ->(dir, row, col) {
        case dir
        when :left
          return [[row, col - 1, :left]]
        when :right
          return [[row, col + 1, :right]]
        when :up, :down
          return [[row, col + 1, :right], [row, col - 1, :left]]
        end
      },
      "/": ->(dir, row, col) {
        case dir
        when :left
          return [[row + 1, col, :down]]
        when :right
          return [[row - 1, col, :up]]
        when :up
          return [[row, col + 1, :right]]
        when :down
          return [[row, col - 1, :left]]
        end
      },
      "\\": ->(dir, row, col) {
        case dir
        when :left
          return [[row - 1, col, :up]]
        when :right
          return [[row + 1, col, :down]]
        when :up
          return [[row, col - 1, :left]]
        when :down
          return [[row, col + 1, :right]]
        end
      },
    }.with_indifferent_access
  end

  def reflect(row, col, dir, energized = Set.new, seen = Set.new)
    stack = [[row, col, dir]]

    while stack.any?
      row, col, dir = stack.pop

      next unless within_bounds?(@data, row, col)
      next if seen.include?([row, col, dir])

      energized.add([row,col])
      seen.add([row, col, dir])

      reflection_proc = @reflections[@data[row][col]]
      reflection_proc.call(dir, row, col).each { |reflection| stack.push(reflection) }
    end

    energized.count
  end

  def pt1
    reflect(0, 0, :right)
  end

  def pt2
    [
      [0].product((0...@data[0].size).to_a).map {|row, col| reflect(row, col, :down) }.max,
      [@data.size - 1].product((0...@data[0].size).to_a).map {|row, col| reflect(row, col, :up) }.max,
      (0...@data.size).to_a.product([0]).map {|row, col| reflect(row, col, :right) }.max,
      (0...@data.size).to_a.product([@data[0].size - 1]).map {|row, col| reflect(row, col, :left) }.max
    ].max
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
