#!/usr/bin/env ruby
# frozen_string_literal: true

puts $stdin.each_line
           .map { |l| l.split.each.map(&:to_i) }
           .transpose
           .map(&:sort)
           .transpose
           .map { |l, r| (l - r).abs }
           .sum
