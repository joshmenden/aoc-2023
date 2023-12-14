#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def place_group(row, groups)
    spring_size = groups.shift
    possibles = place_spring(row, spring_size)

    return possibles if groups.empty?
    return possibles.map { |p| place_group(p, groups.dup) }
  end

  def place_spring(row, gsize)
    possibles = []
    row.each_cons(gsize).with_index do |group, ind|
      next unless group.all? {|el| el == "?" || el == "#" }
      next unless ind == 0 || [".", "?"].include?(row[ind - 1]) # preceded by operational spring
      next unless ind == (row.size - gsize) || [".", "?"].include?(row[ind + gsize]) # followed by operational spring

      poss = row.dup
      poss[ind, gsize] = "#" * gsize
      possibles << poss
    end

    possibles
  end

  def pt1
    @data
      .scan(/([.#?]*) ((?:\d,?)*)/)
      .map do |m|
        [
          m[0].split(""),
          m[1].split(",").map(&:to_i)
        ]
      end
      .reduce(0) do |acc, (row, groups)|
        acc + place_group(row, groups.dup)
                .flatten(groups.length - 1)
                .uniq
                .map(&:join)
                .select {|r| r.scan(/#+/).map {|m| m.length } == groups }
                .count
      end
  end

  def pt2
    # what if removed all groups that already had a match
  end
end

filename = "sample.txt"
# filename = "input.txt"
Day.new(filename).solve!
