#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

DIRS = [1, -1].map { |n| [n + 0i, n * 1i] }.flatten.freeze

def find_whole_region(plant, loc, plants, plant_locs)
  max_loc = Complex(plants.first.size - 1, plants.size - 1)

  DIRS.map { |d| loc + d }
      .each do |adj|
        next unless !plant_locs.member?(adj) &&
                    %w[
                      imag real
                    ].all? { |m| adj.send(m).between?(0, max_loc.send(m)) } &&
                    plants[adj.imag][adj.real] == plant

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

    plant = plants[y][x]
    plant_locs = Set[start]
    plant_locs = find_whole_region(plant, start, plants, plant_locs)
    region_locs[start] = plant_locs
    visited_locs << plant_locs
  end
end

fences = region_locs.values.uniq.map do |plant_locs|
  fence_cnt = 0
  plant_locs.each do |loc|
    DIRS.map { |d| loc + d }
        .each do |adj|
          next if plant_locs.member?(adj) &&
                  %w[
                    imag real
                  ].none? { |m| !adj.send(m).between?(0, max_loc.send(m)) }

          fence_cnt += 1
        end
  end

  { region_size: plant_locs.size, fence_cnt: fence_cnt }
end

puts fences.map { |f| f.values.reduce(1, :*) }.sum
