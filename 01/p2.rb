#!/usr/bin/env ruby
# frozen_string_literal: true

lefts = []
freq = Hash.new(0)
$stdin.each_line
      .map { |line| line.chomp.split.map(&:to_i) }
      .each do |l, r|
        lefts << l
        freq[r] += 1
      end

puts lefts.map { |l| l * freq[l] }.sum
