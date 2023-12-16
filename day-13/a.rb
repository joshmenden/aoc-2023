#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def desmudge(field, row_ind, col_ind)
    newf = field.dup
    newf[row_ind][col_ind] = newf[row_ind][col_ind] == "." ? "#" : "."

    newf
  end

  def vertical_reflection(field, all: false)
    compare_reflection(field.transpose, field[0].size - 1, ->(divider) { divider + 1 }, all: all)
  end

  def horizontal_reflection(field, all: false)
    compare_reflection(field, field.size - 1, ->(divider) { (divider + 1) * 100 }, all: all)
  end

  def new_reflection(field, reflection_method: :horizontal_reflection)
    (field.size).times do |row_ind|
      (field[0].size).times do |col_ind|
        copy = field.map(&:dup)
        desmudged = desmudge(copy, row_ind, col_ind)
        vr = send(reflection_method, desmudged, all: true)
        if vr.present?
          vr.delete(send(reflection_method, field))
          return vr.first if vr.length > 0
        end
      end
    end

    nil
  end

  def compare_reflection(field, n, puzzlify_proc, all: false)
    all_puzzles = Set.new
    reflection_div = nil

    n.times do |left_div|
      counter = 0
      loop do
        if left_div - counter < 0
          puzzle = puzzlify_proc.call(left_div)
          all_puzzles.add(puzzle)
          return puzzle unless all
          break
        elsif left_div + 1 + counter > n
          puzzle = puzzlify_proc.call(left_div)
          all_puzzles.add(puzzle)
          return puzzle unless all
          break
        elsif field[left_div - counter] == field[left_div + 1 + counter]
          counter += 1
        else
          break
        end
      end
    end

    return all ? all_puzzles : nil
  end

  def pt1
    @data
      .split("\n\n")
      .map {|f| twod_arr(f)}
      .reduce(0) { |acc, field| acc + (vertical_reflection(field) || horizontal_reflection(field)) }
  end

  def pt2
    @data
      .split("\n\n")
      .map {|f| twod_arr(f)}
      .each_with_index.reduce(0) { |acc, (field, ind)| acc + (new_reflection(field, reflection_method: :vertical_reflection) || new_reflection(field, reflection_method: :horizontal_reflection)) }
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
