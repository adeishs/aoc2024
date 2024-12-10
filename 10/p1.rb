#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

DIRS = [1, -1].map { |d| [d + 0i, d * 1i] }.flatten.freeze

locs = Hash.new { |h, k| h[k] = Set.new }
heights = $stdin.each_line
                .map
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

reachable_peaks = Hash.new { |h, k| h[k] = Set.new }
trail_counts = Hash.new(0)

9.downto(0).each do |h|
  locs[h].each do |loc|
    if h == 9
      reachable_peaks[loc] = Set[loc]
      trail_counts[loc] = 1
    end

    DIRS.map { |d| loc + d }
        .select do |next_loc|
          nx = next_loc.real
          ny = next_loc.imag
          ny.between?(0, heights.size - 1) &&
            nx.real.between?(0, heights.first.size - 1) &&
            heights[ny][nx] == h - 1
        end
        .each do |next_loc|
          reachable_peaks[next_loc] |= reachable_peaks[loc]
          trail_counts[next_loc] += trail_counts[loc]
        end
  end
end

puts locs[0].map { |l| reachable_peaks[l].size }.sum
