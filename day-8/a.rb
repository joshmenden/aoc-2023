#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  class Node
    attr_accessor :val, :left, :right

    def initialize(val, left = nil, right = nil)
      @val = val
      @left = left
      @right = right
    end
  end

  class Tree
    attr_accessor :root

    def initialize(root = nil)
      @root = root
    end
  end

  def parse_data
    @data = @data.split("\n\n")
    @dirs = @data.shift.split("")
    @node_data = @data.pop.scan(/(.*) = \((.*), (.*)\)/)
    @start = "AAA"
    @end = "ZZZ"
  end

  def build_tree(root_node)
    root_i = @node_data.index {|rt,l,r| rt == root_node.val }
    return root_node if root_i.nil?

    rt, l, r = @node_data[root_i]

    if @nodes.key?(l)
      root_node.left = @nodes[l]
    else
      @nodes[l] = Node.new(l)
      root_node.left = build_tree(@nodes[l])
    end

    if @nodes.key?(r)
      root_node.right = @nodes[r]
    else
      @nodes[r] = Node.new(r)
      root_node.right = build_tree(@nodes[r])
    end

    return root_node
  end

  def pt1
    @nodes = {@start => Node.new(@start)}
    tree = Tree.new(build_tree(@nodes[@start]))
    curr = tree.root

    i = 0
    loop do
      dir = @dirs[i % @dirs.length]
      curr = dir == "L" ? curr.left : curr.right
      
      i += 1
      break if curr.val == @end
    end

    i
  end

  def pt2
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
