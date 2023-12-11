#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def expand
    y_candidates = []
    twod_arr(@data).transpose.each_with_index { |r, ind| y_candidates << ind if r.all? {|val| val == "."} }

    x_expanded = twod_arr(@data)
      .each_with_object([]) { |r, newarr| newarr << r.dup << (r.all? {|c| c == "." } ? r.dup : nil) }
      .compact

    cosmos = []
    x_expanded.each do |r|
      # require "byebug"; byebug;
      y_candidates.sort.reverse_each do |c|
        r.insert(c, r[c])
      end
      cosmos << r
    end

    cosmos
  end

  def find_galaxies(cosmos)
    galaxies = []
    cosmos.each_with_index { |r, rind| r.each_with_index { |val, cind| galaxies << [rind, cind] if val == "#" } }

    galaxies
  end

  def relevant_children(pos, goal)
    children = []
    r, c = pos
    gr, gc = goal

    directions = []
    if gr >= r
      directions << :down
    elsif gr < r
      directions << :up
    end

    if gc >= c
      directions << :right
    elsif gc < c
      directions << :left
    end

    case directions
    when [:down, :right]
      return [
        [r + 1, c],
        [r, c + 1],
      ]
    when [:down, :left]
      return [
        [r + 1, c],
        [r, c - 1],
      ]
    when [:up, :right]
      return [
        [r - 1, c],
        [r, c + 1],
      ]
    when [:up, :left]
      return [
        [r - 1, c],
        [r, c - 1],
      ]
    end
  end

  def shortest_path(cosmos, combo)
    start, goal = combo
    queue = [[start]]
    visited = Set.new
    visited.add(start)

    while !queue.empty?
      # require "byebug"; byebug;
      path = queue.shift
      pos = path.last

      if pos == goal
        @shortest_paths[[start, goal]] = path
        @shortest_paths[[goal, start]] = path
        return path
      end

      if @shortest_paths.key?([pos, goal])
        shortest = path.dup.concat(@shortest_paths[[pos, goal]].dup)
        @shortest_paths[[start, goal]] = shortest
        @shortest_paths[[goal, start]] = shortest

        return shortest
      end

      relevant_children(pos, goal).each do |new_pos|
        # require "byebug"; byebug;
        next if visited.include?(new_pos)
        next if !within_bounds?(cosmos, new_pos[0], new_pos[1])

        visited << new_pos
        new_path = path.dup
        new_path << new_pos
        queue << new_path
      end
    end
  end

  def pt1
    @shortest_paths = {}
    cosmos = expand 
    galaxies = find_galaxies(cosmos)
    combinations = galaxies.combination(2).to_a
    counter = 0
    combinations.reduce(0) do |acc, combo|
      counter += 1
      puts "Processing combination number #{counter}, (#{combo}) of #{combinations.count}"
      acc + shortest_path(cosmos, combo).length - 1
    end
  end

  def pt2
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
