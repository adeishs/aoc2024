#!/usr/bin/env ruby
# frozen_string_literal: true

lines = $stdin.each_line
              .map { |line| line.chomp.split }.flatten

lefts = lines.each_slice(2).map { |p| p.first.to_i }.sort
rights = lines.each_slice(2).map { |p| p.last.to_i }.sort

puts lefts.map.with_index { |l, i| (l - rights[i]).abs }.sum
