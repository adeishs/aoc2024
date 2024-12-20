#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

DIRS = [1, -1].map { |d| [d + 0i, d * 1i] }.flatten.freeze
WALL_TILE = '#'
EMPTY_TILE = '.'
START_TILE = 'S'
END_TILE = 'E'

def obj_at?(tiles, loc, tile)
  tiles[loc.imag][loc.real] == tile
end

def parse(lines)
  locs = Hash.new { |h, k| h[k] = Set.new }
  tiles = lines.map.with_index do |line, y|
    line.chomp.each_char.map.with_index do |t, x|
      locs[t] << Complex(x, y)
      t
    end
  end

  [tiles, locs]
end

def solve(tiles, locs)
  start_loc = locs[START_TILE].first
  end_loc = locs[END_TILE].first
  path_locs = []
  visiteds = Set[{ loc: start_loc, dir: 1 + 0i }]
  queue = [start_loc]

  until queue.empty?
    curr_loc = queue.shift
    path_locs.unshift(curr_loc)

    break if curr_loc == end_loc

    visiteds << curr_loc

    DIRS.each do |dir|
      next_loc = curr_loc + dir
      next if obj_at?(tiles, next_loc, WALL_TILE) ||
              visiteds.member?(next_loc)

      queue << next_loc
    end
  end

  path_locs
end

path_locs = solve(*parse($stdin.each_line))

skip_cnt = 0
saveds = Hash.new(0)

path_locs.each.with_index do |loc0, i0|
  (i0 + 1...path_locs.size).each do |i1|
    loc1 = path_locs[i1]
    saved = i1 - i0

    diff = Complex((loc0.real - loc1.real).abs, (loc0.imag - loc1.imag).abs)

    man_dist = diff.rect.sum
    next unless man_dist <= 20

    saved -= man_dist
    saveds[saved] += 1

    skip_cnt += 1 if saved >= 100
  end
end

puts skip_cnt
