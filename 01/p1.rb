#!/usr/bin/env ruby
# frozen_string_literal: true

ids = [[], []]
$stdin.each_line { |l| l.split.each.with_index { |v, i| ids[i] << v.to_i } }

puts ids[0].sort.zip(ids[1].sort).map { |l, r| (l - r).abs }.sum
