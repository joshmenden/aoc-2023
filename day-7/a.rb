#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution

  def hand_type(hand)
    h = hand.split("").sort
    return 7 if h.uniq.length == 1
    return 6 if h.uniq.length == 2 && (h.first(4).uniq.length == 1 || h.last(4).uniq.length == 1)
    return 5 if (h.first(2).uniq.length == 1 && h.last(3).uniq.length == 1) || (h.first(3).uniq.length == 1 && h.last(2).uniq.length == 1)
    return 4 if h.uniq.length == 3 && (h.first(3).uniq.length == 1 || h.last(3).uniq.length == 1 || h[1..3].uniq.length == 1)
    return 3 if h.uniq.length == 3 # ?
    return 2 if h.uniq.length == 4
    return 1 if h.uniq.length == 5
  end

  def hand_strength(a, b)
    strength = { "A": 14, "K": 13, "Q": 12, "J": 11, "T": 10, "9": 9, "8": 8, "7": 7, "6": 6, "5": 5, "4": 4, "3": 3, "2": 2, }
    i = 0
    loop do
      if strength[a[0].split("")[i].to_sym] < strength[b[0].split("")[i].to_sym]
        return -1
      elsif strength[a[0].split("")[i].to_sym] > strength[b[0].split("")[i].to_sym]
        return 1
      else
        i += 1
      end
    end
  end

  def pt1
    @data.scan(/(.*) (\d+)/)
      .map {|h,b| [h, b.to_i]}
      .sort do |ha, hb|
        if hand_type(ha[0]) < hand_type(hb[0])
          -1
        elsif hand_type(ha[0]) > hand_type(hb[0])
          1
        else
          hand_strength(ha, hb)
        end
      end.each_with_index.reduce(0) {|acc, ((h, b), i)| acc + (b.to_i * (i+1)) }
  end

  def pt2
  end
end

filename = "sample.txt"
filename = "input.txt"
# filename = "test.txt"
Day.new(filename).solve!
