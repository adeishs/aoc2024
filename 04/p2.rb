#!/usr/bin/env ruby
# frozen_string_literal: true

DIRS = [-1, 1].repeated_permutation(2).map { |cs| Complex(*cs) }

def scan_dir(rows, candidate_coord, dir)
  [dir, dir * (0 + 1i)].all? do |d|
    m_pos = candidate_coord + d
    s_pos = candidate_coord - d

    rows[m_pos.imag][m_pos.real] == 'M' &&
      rows[s_pos.imag][s_pos.real] == 'S'
  end
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
