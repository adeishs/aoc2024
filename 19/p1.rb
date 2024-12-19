#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

@memo = {}

def check_possible?(avails, desired_pat, min_desired_len)
  return true if desired_pat.empty?

  if avails.member?(desired_pat)
    @memo[desired_pat] = true
    return true
  end

  (1...[min_desired_len, desired_pat.size].min).each do |i|
    s = desired_pat[0...i]
    e = desired_pat[i...desired_pat.size]

    [s, e].each do |k|
      @memo[k] = check_possible?(avails, k, min_desired_len) if @memo[k].nil?
    end

    return true if [s, e].all? { |k| @memo[k] }
  end

  false
end

def parse_input(inp)
  avail_str, desired_str = inp.split("\n\n")

  [avail_str.split(', ').sort.to_set, desired_str.split("\n")]
end

avails, desireds = parse_input($stdin.read)
min_desired_len = desireds.min.size
puts desireds.select { |p| check_possible?(avails, p, min_desired_len) }.size
