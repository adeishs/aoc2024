#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

DIRS = [1, -1].map { |d| [d + 0i, d * 1i] }.flatten.freeze

def solve(corr_locs, max_loc)
  q = [{ loc: 0 + 0i, dist: 0 }]
  visiteds = Set[q.last[:loc]]

  until q.empty?
    curr = q.shift
    return curr[:dist] if curr[:loc] == max_loc

    DIRS.each do |d|
      n = curr[:loc] + d

      next if corr_locs.member?(n) ||
              visiteds.member?(n) ||
              !n.imag.between?(0, max_loc.imag) ||
              !n.real.between?(0, max_loc.real)

      visiteds << n
      q.append({ loc: n, dist: curr[:dist] + 1 })
    end
  end

  nil
end

def parse(lines, num_of_bytes)
  max_x, max_y, corr_locs =
    lines.each_with_object([[], [], []]) do |line, os|
      ns = line.chomp.split(',').map(&:to_i)
      [0, 1].each { |i| os[i] = [[os[i].first || -1, ns[i]].max] }
      os.last << Complex(*ns) if os.last.size < num_of_bytes
    end

  [corr_locs.to_set, Complex(max_x.first, max_y.first)]
end

puts solve(*parse($stdin.each_line, 1024))
