#!/usr/bin/env ruby
# frozen_string_literal: true

lefts, rights = $stdin.each_line
                      .flat_map { |line| line.chomp.split.map(&:to_i) }
                      .partition.with_index { |_, i| i.even? }
                      .map(&:sort)

puts lefts.map.with_index { |l, i| (l - rights[i]).abs }.sum
