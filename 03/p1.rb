#!/usr/bin/env ruby
# frozen_string_literal: true

def parse(line)
  line.scan(/mul\(\d+,\d+\)/)
      .map { |m| m.scan(/\d+/).map(&:to_i).reduce(:*) }
      .sum
end

puts $stdin.each_line
           .map { |line| parse(line) }
           .sum
