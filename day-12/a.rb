#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def place_group(row, groups)
    cache_key = [row.dup, groups.dup]
    return @place_group_cache[cache_key] if @place_group_cache.key?(cache_key)

    spring_size = groups.shift
    possibles = place_spring(row, spring_size)

    result = if groups.empty?
               possibles
             else
               possibles.map { |p| place_group(p, groups.dup) }
             end

    @place_group_cache[cache_key] = result
  end

  def place_spring(row, gsize)
    cache_key = [row.dup, gsize.dup]
    return @place_spring_cache[cache_key] if @place_spring_cache.key?(cache_key)

    possibles = []
    row.chars.each_cons(gsize).with_index do |group, ind|
      next unless group.all? {|el| el == "?" || el == "#" }
      next unless ind == 0 || [".", "?"].include?(row[ind - 1]) # preceded by operational spring
      next unless ind == (row.size - gsize) || [".", "?"].include?(row[ind + gsize]) # followed by operational spring

      poss = row.dup
      poss[ind, gsize] = "#" * gsize
      possibles << poss
    end

    @place_spring_cache[cache_key] = possibles
  end

  def solve(factor)
    @place_group_cache = {}
    @place_spring_cache = {}
    @data
      .scan(/([.#?]*) ((?:\d,?)*)/)
      .map do |m|
        [
          ([m[0]] * factor).join("?"),
          m[1].split(",").map(&:to_i) * factor
        ]
      end
      # .yield_self { |rows| [rows[0]] }
      .reduce(0) do |acc, (row, groups)|
        acc + place_group(row, groups.dup.sort.reverse)
          .flatten(groups.length - 1)
          .uniq
          .select {|r| r.scan(/#+/).map {|m| m.length } == groups }
          .count
      end
  end

  def pt1
    solve(1)
  end

  def pt2
    # solve(5)
  end
end

filename = "sample.txt"
# filename = "input.txt"
Day.new(filename).solve!
