#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def move_to_ind(row, rock_ind, row_ind)
    stable_ind = row[0..rock_ind].rindex("#")
    return row.index(".") if stable_ind.nil?
    opening = row[stable_ind..].index(".")
    opening.nil? ? nil : stable_ind + opening
  end

  def tilt_procs
    {
      north: { mod: ->(table) { table.transpose }, revert: ->(table) { table.transpose }, },
      south: { mod: ->(table) { table.reverse.transpose }, revert: ->(table) { table.transpose.reverse }, },
      west: { mod: ->(table) { table }, revert: ->(table) { table }, },
      east: { mod: ->(table) { table.map(&:reverse) }, revert: ->(table) { table.map(&:reverse) }, },
    }
  end

  def tilt(table, direction)
    tilt_proc = tilt_procs[direction][:mod]
    revert_proc = tilt_procs[direction][:revert]

    tilted_table = tilt_proc.call(table)

    tilted_table.each_with_index do |r, row_ind|
      r.each_with_index do |spot, ind|
        next unless spot == "O"
        next if r[0..ind].all? {|el| ["O", "#"].include?(el) }

        mover = move_to_ind(r, ind, row_ind)
        next unless mover.present? && mover < ind

        r[mover] = "O"
        r[ind] = "."
      end
    end

    return revert_proc.call(tilted_table)
  end

  def pt1
    table = tilt(twod_arr(@data), :north)
    table.each_with_index.reduce(0) { |acc, (row, ind)| acc + (row.count("O") * (table.size - ind)) }
  end

  def pt2
    table = twod_arr(@data)
    table = tilt(table, :north)
        
    table.each_with_index.reduce(0) do |acc, (row, ind)|
      acc + (row.count("O") * (table.size - ind))
    end
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
