#!/usr/bin/env ruby
# frozen_string_literal: true

lines = $stdin.each_line
              .map { |line| line.chomp.split }.flatten

lefts = lines.each_slice(2).map { |p| p.first.to_i }
freq = Hash[
  *lines.each_slice(2)
        .map { |p| p.last.to_i }
        .group_by { |v| v }
        .flat_map { |k, v| [k, v.size] }
]

puts lefts.map { |l| l * (freq[l] || 0) }.sum
