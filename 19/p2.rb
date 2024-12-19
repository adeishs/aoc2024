#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

@memo = {}

def count_possible_arrs(avails, desired_pat, max_avail_len)
  return 1 if desired_pat.empty?

  num_of_alts = avails.member?(desired_pat) ? 1 : 0

  (1...[max_avail_len + 1, desired_pat.size].min).each do |i|
    next unless avails.member?(desired_pat[0...i])

    e = desired_pat[i...desired_pat.size]
    @memo[e] = count_possible_arrs(avails, e, max_avail_len) if @memo[e].nil?
    num_of_alts += @memo[e]
  end

  num_of_alts
end

def parse_input(inp)
  avail_str, desired_str = inp.split("\n\n")

  [avail_str.split(', ').sort.to_set, desired_str.split("\n")]
end

avails, desireds = parse_input($stdin.read)
max_avail_len = avails.map(&:size).max
puts desireds.map { |p| count_possible_arrs(avails, p, max_avail_len) }.sum
