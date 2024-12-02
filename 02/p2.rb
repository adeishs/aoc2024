#!/usr/bin/env ruby
# frozen_string_literal: true

def safe?(levels)
  a, b = levels[0..1]
  return false unless (b - a).abs.between?(1, 3)

  s = b <=> a
  levels[1...levels.size].each_cons(2)
                         .all? { |x, y| (y <=> x) == s && (y - x).abs <= 3 }
end

def dampened_safe?(levels)
  return true if safe?(levels)

  (0...levels.size).any? do |i|
    safe?(levels[0...i] + levels[i + 1...levels.size])
  end
end

puts $stdin.each_line
           .select { |line| dampened_safe?(line.split.map(&:to_i)) }
           .size
