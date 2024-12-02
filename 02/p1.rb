#!/usr/bin/env ruby
# frozen_string_literal: true

def get_levels(line)
  line.split.map(&:to_i)
end

def safe?(levels)
  a, b = levels[0..1]
  return false unless (b - a).abs.between?(1, 3)

  s = b <=> a
  levels[1...levels.size].each_cons(2)
                         .all? { |x, y| (y <=> x) == s && (y - x).abs <= 3 }
end

puts $stdin.each_line
           .map { |l| get_levels(l) }
           .select { |ls| safe?(ls) }
           .size
