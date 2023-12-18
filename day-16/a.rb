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

  def pt1
    @energized = Set.new
    @seen = Set.new
    reflect(0, 0, :right)
    @energized.count
  end

  def reflect(row, col, dir)
    return unless within_bounds?(@data, row, col)
    return if @seen.include?([row, col, dir])

    @energized.add([row,col])
    @seen.add([row, col, dir])

    reflection_proc = @reflections[@data[row][col]]
    reflection_proc.call(dir, row, col).each do |(row, col, dir)|
      reflect(row, col, dir)
    end
  end

  def pt2
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
