#!/usr/bin/env ruby
# frozen_string_literal: true

lefts, rights = $stdin.each_line
                      .map { |line| line.chomp.split.map(&:to_i) }
                      .flatten
                      .partition.with_index { |_, i| i.even? }

freq = Hash[*rights.group_by { |v| v }.flat_map { |k, v| [k, v.size] }]

puts lefts.map { |l| l * (freq[l] || 0) }.sum
