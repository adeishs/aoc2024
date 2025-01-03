#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

ALNUMS = Set.new([*'A'..'Z', *'a'..'z', *'0'..'9']).freeze

def get_antenna_loc(tiles, row_num)
  tiles.each_char
       .map
       .with_index { |t, x| ALNUMS.member?(t) ? [t, Complex(x, row_num)] : nil }
       .reject(&:nil?)
       .flatten
end

def get_antennas(rows)
  rows.map
      .with_index { |tiles, y| get_antenna_loc(tiles, y) }
      .reject(&:empty?)
      .each_with_object(Hash.new { |h, k| h[k] = Set.new }) do |a_locs, antenna|
        a_locs.each_slice(2) { |a_name, loc| antenna[a_name] << loc }
      end
end

def get_antinodes(rows)
  max = Complex(rows.first.size - 1, rows.size - 1)
  in_range = lambda { |l|
    l.imag.between?(0, max.imag) && l.real.between?(0, max.real)
  }
  get_antennas(rows).values
                    .each_with_object(Set.new) do |locs, antinodes|
                      locs.to_a
                          .permutation(2)
                          .each do |pair_locs|
                            d = pair_locs[1] - pair_locs[0]
                            an_loc = pair_locs[0] + d
                            while in_range.call(an_loc)
                              antinodes << an_loc
                              an_loc += d
                            end
                          end
                    end
end

puts get_antinodes($stdin.each_line.map(&:chomp)).size
