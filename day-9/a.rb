#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @data = @data.split("\n").map {|l| l.scan(/-?\d+/).map(&:to_i)}
  end

  def get_zero(hist)
    stack = [hist]

    while stack.last.any? {|v| v != 0 }
      stack << stack.last.each_cons(2).map {|a, b| b - a}
    end

    stack
  end

  def extrapolate(hist, parent_add_proc, new_val_proc)
    stack = get_zero(hist).reverse

    stack.each_cons(2) do |child, parent|
      parent_add_proc.call(parent, child)
    end

    new_val_proc.call(stack.last)
  end

  def pt1
    @data.reduce(0) { |acc, hist| acc + extrapolate(hist, ->(p, c) { p << (p.last + c.last)}, ->(p) {p.last}) }
  end

  def pt2
    @data.reduce(0) { |acc, hist| acc + extrapolate(hist, ->(p, c) { p.unshift(p.first - c.first)}, ->(p) {p.first}) }
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
