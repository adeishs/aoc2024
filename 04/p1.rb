#!/usr/bin/env ruby
# frozen_string_literal: true

TARGET = 'XMAS'
DIRS = [*-1..1].repeated_permutation(2)
               .reject { |els| els.all?(&:zero?) }
               .map { |cs| Complex(*cs) }

def scan_dir(rows, candidate_coord, dir)
  in_range = lambda { |coord|
    coord.imag.between?(0, rows.size - 1) &&
      coord.real.between?(0, rows.first.size - 1)
  }
  (0...TARGET.size).map { |i| candidate_coord + i * dir }
                   .select { |c| in_range.call(c) }
                   .map { |c| rows[c.imag][c.real, 1] }
                   .join
end

def scan_dirs(rows, coord)
  DIRS.select { |d| scan_dir(rows, coord, d) == TARGET }.size
end

def find_targets(rows)
  rows.map.with_index do |row, r|
    (0...row.size).find_all { |c| row[c] == 'X' }.map { |c| Complex.new(c, r) }
  end.flatten
      .map { |coord| scan_dirs(rows, coord) }
end

rows = $stdin.each_line.map(&:chomp)
puts find_targets(rows).sum
