#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @card_strength = { "A": 14, "K": 13, "Q": 12, "J": 11, "T": 10, "9": 9, "8": 8, "7": 7, "6": 6, "5": 5, "4": 4, "3": 3, "2": 2, }.with_indifferent_access
  end

  def hand_strength(h)
    return 7 if h.uniq.length == 1
    return 6 if h.uniq.length == 2 && (h.first(4).uniq.length == 1 || h.last(4).uniq.length == 1)
    return 5 if (h.first(2).uniq.length == 1 && h.last(3).uniq.length == 1) || (h.first(3).uniq.length == 1 && h.last(2).uniq.length == 1)
    return 4 if h.uniq.length == 3 && (h.first(3).uniq.length == 1 || h.last(3).uniq.length == 1 || h[1..3].uniq.length == 1)
    return 3 if h.uniq.length == 3
    return 2 if h.uniq.length == 4
    return 1 if h.uniq.length == 5
  end

  def best_card(str)
    str = str.gsub("J", "")
    return "K" if str.blank?

    char_counts = Hash.new(0)
    str.each_char { |char| char_counts[char] += 1 }
    char_counts.key(char_counts.values.max)
  end

  def comp_cards(a, b)
    a[0].each_char.with_index do |char, i|
      a_strength = @card_strength[char]
      b_strength = @card_strength[b[0][i]]
      return a_strength <=> b_strength if a_strength != b_strength
    end
  end

  def _solve(hand_mod)
    h = hand_mod
    @data.scan(/(.*) (\d+)/)
      .map {|h,b| [h, b.to_i]}
      .sort { |ha, hb| hand_strength(h.call(ha[0])) < hand_strength(h.call(hb[0])) ? -1 : hand_strength(h.call(ha[0])) > hand_strength(h.call(hb[0])) ? 1 : comp_cards(ha, hb) }
      .each_with_index.reduce(0) {|acc, ((h, b), i)| acc + (b.to_i * (i+1)) }
  end

  def pt1
    _solve(->(hand) {hand.split("").sort})
  end

  def pt2
    @card_strength[:J] = 1
    _solve(->(hand) {hand.gsub("J", best_card(hand)).split("").sort})
  end
end

filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
