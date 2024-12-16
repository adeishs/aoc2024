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

def solve(r_loc, r_dir, dist, step_cnt, tiles, start_loc, visiteds, loc_dist)
  score_paths = [
    { score: Float::INFINITY, paths: Set[start_loc] }
  ]
  path = Set[r_loc]
  return [dist, path, visiteds, loc_dist] if obj_at?(tiles, r_loc, END_TILE)

  (DIRS - [-r_dir]).each do |d|
    nd = r_loc + d
    return [dist + 1, path, visiteds, loc_dist] if obj_at?(tiles, nd, END_TILE)

    next unless obj_at?(tiles, nd, EMPTY_TILE)

    new_dist = dist + (r_dir == d ? 1 : 1001)
    next if visiteds.member?({ loc: nd, dir: d }) &&
            loc_dist[nd] + 1000 < new_dist

    visiteds << { loc: nd, dir: d }
    loc_dist[nd] = new_dist

    score, path, visiteds, loc_dist = solve(
      nd, d, new_dist, step_cnt + 1, tiles, start_loc, visiteds, loc_dist
    )
    score_paths << { score: score, paths: path }
  end

  min_score_paths = score_paths.min { |a, b| a[:score] <=> b[:score] }

  path |= min_score_paths[:paths]

  [min_score_paths[:score], path, visiteds, loc_dist]
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

tiles, locs = parse($stdin.each_line)

start_loc = locs[START_TILE].first
loc_dist = { start_loc => 0 }
visiteds = Set[{ loc: start_loc, dir: 1 + 0i }]

puts solve(start_loc, 1 + 0i, 0, 1, tiles, start_loc, visiteds, loc_dist).first
