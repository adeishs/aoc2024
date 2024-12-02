#!/usr/bin/env ruby
# frozen_string_literal: true

def safe?(levels)
  a, b = levels[0..1]
  return false unless (b - a).abs.between?(1, 3)

  s = b <=> a
  levels[1...levels.size].each_cons(2)
                         .all? { |x, y| (y <=> x) == s && (y - x).abs <= 3 }
end

puts $stdin.each_line
           .select { |line| safe?(line.split.map(&:to_i)) }
           .size
