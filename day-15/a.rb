#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @data = @data.split(",").map { |s| s.gsub("\n", "") }
  end

  def hash(seq)
    seq.each_char.reduce(0) { |curr, char| ((curr + char.ord) * 17) % 256 }
  end

  def pt1
    @data.reduce(0) { |acc, seq| acc + hash(seq) }
  end

  def pt2
    boxes = Array.new(256) {[]}
    label_to_box = {}

    @data.map { |seq| seq.scan(/(\w+)([-=])(\d?)/)[0] }.each do |(label, op, strength)|
      label_to_box[label] ||= hash(label)
      box = boxes[label_to_box[label]]

      case op
      when "-"
        box.reject! { |(lab, _)| lab == label }
      when "="
        ind = box.index { |(lab, _)| lab == label }
        ind ? box[ind][1] = strength.to_i : box << [label, strength.to_i]
      end
    end

    boxes.each_with_index.reduce(0) do |acc, (box, box_i)|
      acc + box.each_with_index.reduce(0) do |sum, ((label, strength), lens_i)|
        sum + ((1 + box_i) * (1 + lens_i) * strength.to_i)
      end
    end
  end
end

filename = "hash.txt"
filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
