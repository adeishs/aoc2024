#!/usr/bin/env ruby
# frozen_string_literal: true

WIDTH = 5
TILE_VAL = {
  '#' => 1,
  '.' => 0
}.freeze

def ident(schem_rows)
  {
    type: schem_rows.first[0] == 1 ? :lock : :key,
    heights: schem_rows[1..WIDTH].transpose.map(&:sum)
  }
end

def parse(input)
  input.split("\n\n")
       .map { |s| ident(s.split.map { |l| l.chars.map { |t| TILE_VAL[t] } }) }
       .partition { |s| s[:type] == :lock }
       .map { |ss| ss.map { |s| s[:heights] } }
end

locks, keys = parse($stdin.read)
puts locks.product(keys)
          .map { |lhs, khs| lhs.zip(khs).map(&:sum) }
          .select { |hs| hs.all? { |h| h <= WIDTH } }
          .size
