#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

DIRS = [1, -1].map { |n| [n + 0i, n * 1i] }.flatten.freeze

def find_whole_region(plant, loc, plants, plant_locs)
  max_loc = Complex(plants.first.size - 1, plants.size - 1)
  in_map = lambda { |loc|
    %w[imag real].all? { |m| loc.send(m).between?(0, max_loc.send(m)) }
  }
  DIRS.map { |d| loc + d }
      .reject do |adj|
        plant_locs.member?(adj) ||
          !in_map.call(adj) ||
          plants[adj.imag][adj.real] != plant
      end
      .each do |adj|
        plant_locs << adj
        plant_locs.merge(find_whole_region(plant, adj, plants, plant_locs))
      end

  plant_locs
end

plants = $stdin.each_line.map(&:chomp)
max_loc = Complex(plants.first.size - 1, plants.size - 1)
visited_locs = Set.new
region_locs = {}

(0..max_loc.imag).each do |y|
  (0..max_loc.real).each do |x|
    start = Complex(x, y)
    next if visited_locs.member?(start)

    plant_locs = find_whole_region(plants[y][x], start, plants, Set[start])
    region_locs[start] = plant_locs
    visited_locs << plant_locs
  end
end

fences = region_locs.values.uniq.map do |plant_locs|
  {
    region_size: plant_locs.size,
    fence_cnt: plant_locs.map do |loc|
                 DIRS.reject { |d| plant_locs.member?(loc + d) }.size
               end.sum
  }
end

puts fences.map { |f| f.values.reduce(1, :*) }.sum
