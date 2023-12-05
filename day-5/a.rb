#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require_relative "../aoc_solution"

class Day < AOCSolution
  def parse_data
    @path = ["seed", "soil", "fertilizer", "water", "light", "temperature", "humidity", "location"]

    @data = @data.split("\n\n")
    @seeds = @data.shift.split(":")[1].split.map(&:to_i)
    @maps = Hash.new

    @data.each do |map|
      map = map.split("\n")
      from, to = map.shift.scan(/(\w+)-to-(\w+)/).flatten
      key = "#{from}-#{to}"
      @maps[key] = { source_ranges: [], destination_ranges: [] }

      map.each do |mapping|
        dstart, sstart, len = mapping.split.map(&:to_i)
        @maps[key][:source_ranges] << (sstart..(sstart + len - 1))
        @maps[key][:destination_ranges] << (dstart..(dstart + len - 1))
      end
    end
  end

  def calculate_destination(from, to, seed)
    matched_mapping_i = @maps["#{from}-#{to}"][:source_ranges].index {|i| i.include?(seed)}
    return seed if matched_mapping_i.nil?

    range_i = (@maps["#{from}-#{to}"][:source_ranges][matched_mapping_i].first - seed).abs
    return @maps["#{from}-#{to}"][:destination_ranges][matched_mapping_i].first + range_i
  end

  def location(seed)
    seed_map = Hash[@path.zip([nil])].merge({"seed" => seed})
    @path.each_cons(2){ |from, to| seed_map[to] = calculate_destination(from, to, seed_map[from]) }

    return seed_map["location"]
  end

  def pt1
    @seeds.map {|s| location(s) }.min
  end

  def pt2
  end
end

# filename = "sample.txt"
filename = "input.txt"
Day.new(filename).solve!
