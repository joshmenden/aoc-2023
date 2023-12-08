#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @data = @data.split("\n\n")
    @dirs = @data.shift.split("")
    @node_data = @data.pop.scan(/(.*) = \((.*), (.*)\)/)
  end

  def steps_to_end(graph, end_proc)
    curr = graph.root

    @dirs.cycle.with_index do |dir, i|
      curr = dir == "L" ? curr.left : curr.right
      return i + 1 if end_proc.call(curr.val)
    end
  end

  def pt1
    steps_to_end(Graph.new(Node.new("AAA"), @node_data), ->(val) { val == "ZZZ" })
  end

  def pt2
    @node_data
      .select {|rt, _l, _r| rt.end_with?("A") }
      .map {|rt, _l, _r| Graph.new(Node.new(rt), @node_data)}
      .map {|g| steps_to_end(g, ->(val) { val.end_with?("Z") }) }
      .reduce(1) { |lcm, num| lcm.lcm(num) }
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
