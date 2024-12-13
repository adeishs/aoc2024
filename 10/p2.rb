#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

DIRS = [1, -1].map { |d| [d + 0i, d * 1i] }.flatten.freeze

def reachable_loc?(heights, curr_loc, next_loc)
  nx = next_loc.real
  ny = next_loc.imag
  ny.between?(0, heights.size - 1) &&
    nx.between?(0, heights.first.size - 1) &&
    heights[ny][nx] == heights[curr_loc.imag][curr_loc.real] - 1
end

def get_next_locs(heights, loc)
  DIRS.map { |d| loc + d }
      .select { |n| reachable_loc?(heights, loc, n) }
end

def count_trails(heights, locs)
  trail_counts = Hash.new(0)

  9.downto(0).each do |h|
    locs[h].each do |loc|
      trail_counts[loc] = 1 if h == 9

      get_next_locs(
        heights, loc
      ).each { |next_loc| trail_counts[next_loc] += trail_counts[loc] }
    end
  end

  locs[0].map { |l| trail_counts[l] }.sum
end

def parse(lines)
  locs = Hash.new { |h, k| h[k] = Set.new }
  heights = lines.map
                 .with_index do |line, y|
                   line.chomp
                       .each_char
                       .map
                       .with_index do |hs, x|
                         h = hs.to_i
                         locs[h] << Complex(x, y)
                         h
                       end
                 end

  [heights, locs]
end

puts count_trails(*parse($stdin.each_line))