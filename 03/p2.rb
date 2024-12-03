#!/usr/bin/env ruby
# frozen_string_literal: true

F = {
  'do()' => 1,
  "don't()" => 0
}.freeze

def parse(line)
  f = 1
  line.scan(/(mul\(\d+,\d+\)|do\(\)|don't\(\))/)
      .map do |ts|
        t = ts.shift
        if t.start_with?('m')
          f * t.scan(/\d+/).map(&:to_i).reduce(:*)
        else
          f = F[t]
          0
        end
      end
end

puts parse($stdin.each_line.map(&:chomp).to_a.join('')).sum
