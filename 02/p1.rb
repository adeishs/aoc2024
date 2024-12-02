#!/usr/bin/env ruby
# frozen_string_literal: true

def parse(line)
  line.split
      .map(&:to_i)
      .each_cons(2)
      .each_with_object([Hash.new(0), Hash.new(0)]) do |els, os|
        os.first[(els.last - els.first).abs] = true
        os.last[els.last <=> els.first] = true
      end
end

def safe?(line)
  diff, dir = parse(line)

  dir.keys.size <= 1 &&
    dir.keys.none?(&:zero?) &&
    diff.keys.none? { |k| k > 3 }
end

puts $stdin.each_line
           .select { |l| safe?(l) }
           .size
