#!/usr/bin/env ruby
# frozen_string_literal: true

DIRS = [-1, 1].repeated_permutation(2).map { |cs| Complex(*cs) }
TARGET = { 1 => 'M', -1 => 'S' }.freeze

def scan_dir(rows, candidate_coord, dir)
  [1, 0 + 1i].product(TARGET.keys)
             .map { |d, s| [candidate_coord + d * s * dir, TARGET[s]] }
             .all? { |pos, ch| rows[pos.imag][pos.real] == ch }
end

def scan_dirs(rows, coord)
  DIRS.any? { |d| scan_dir(rows, coord, d) }
end

def find_targets(rows)
  rows[1...rows.size - 1].map.with_index do |row, r|
    (1...row.size - 1).find_all { |c| row[c] == 'A' }
                      .map { |c| Complex.new(c, r + 1) }
  end.flatten.select { |coord| scan_dirs(rows, coord) }
end

rows = $stdin.each_line.map(&:chomp)
puts find_targets(rows).size
