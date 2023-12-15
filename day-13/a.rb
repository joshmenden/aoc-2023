#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def vertical_reflection field
    compare_reflection(field.transpose, field[0].size - 1, ->(divider) { divider + 1 })
  end

  def horizontal_reflection field
    compare_reflection(field, field.size - 1, ->(divider) { (divider + 1) * 100 })
  end

  def compare_reflection(field, n, puzzlify_proc)
    reflection_div = nil

    n.times do |left_div|
      counter = 0
      loop do
        if left_div - counter < 0
          return puzzlify_proc.call(left_div)
        elsif left_div + 1 + counter > n
          return puzzlify_proc.call(left_div)
        elsif field[left_div - counter] == field[left_div + 1 + counter]
          counter += 1
        else
          break
        end
      end
    end

    return nil
  end

  def pt1
    @data
      .split("\n\n")
      .map {|f| twod_arr(f)}
      .reduce(0) { |acc, field| acc + (vertical_reflection(field) || horizontal_reflection(field)) }
  end

  def pt2
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
