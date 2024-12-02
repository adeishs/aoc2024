#!/usr/bin/env ruby
# frozen_string_literal: true

def get_levels(line)
  line.split.map(&:to_i)
end

def get_diff_dir(levels)
  levels.each_cons(2)
        .each_with_object([Hash.new(0), Hash.new(0)]) do |els, os|
          os.first[(els.last - els.first).abs] = true
          os.last[els.last <=> els.first] = true
        end
end

def safe?(levels)
  diff, dir = get_diff_dir(levels)

  dir.keys.size <= 1 &&
    dir.keys.none?(&:zero?) &&
    diff.keys.none? { |k| k > 3 }
end

def dampened_safe?(levels)
  (0...levels.size).any? do |i|
    safe?(levels[0...i] + levels[i + 1...levels.size])
  end
end

puts $stdin.each_line
           .map { |l| get_levels(l) }
           .select { |ls| safe?(ls) || dampened_safe?(ls) }
           .size
