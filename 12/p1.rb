#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def assign_region(regions, loc, region)
  return 1 unless regions[loc].nil?

  regions[loc] = region
  [
    1, -1, 0 + 1i, 0 + -1i
  ].map { |d| loc + d }
    .select { |l| l.imag.between?(0, regions.size - 1) && l.real.between?(0, regions.first.size - 1) }
    .select { |loc| loc }
end

def fence(plants)
  fences = Hash.new { |h, k| h[k] = Set.new }
  regions = {}
  plants.each.with_index do |row, y|
    row.chars.each.with_index do |p, x|
      fences[Complex(x, y)] |= (
        (y.zero? || p != plants[y - 1][x] ? [0 + -1i] : []) +
        (y == plants.size - 1 || p != plants[y + 1][x] ? [0 + 1i] : []) +
        (x.zero? || p != plants[y][x - 1] ? [-1 + 0i] : []) +
        (x == plants[y].size - 1 || p != plants[y][x + 1] ? [1 + 0i] : [])
      ).flatten
    end
  end

  fences
end

plants = $stdin.each_line.map(&:chomp)
puts fence(plants)
