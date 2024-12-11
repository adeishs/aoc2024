#!/usr/bin/env ruby
# frozen_string_literal: true

@memo = {}

def transform(stone, i)
  stone = stone.to_i.to_s
  return @memo[{ stone: stone, i: i }] if @memo[{ stone: stone, i: i }]

  return 1 if i.zero?

  @memo[{ stone: stone, i: i }] =
    if stone == '0'
      transform('1', i - 1)
    elsif stone.size.even?
      mid = stone.size / 2
      [
        transform(stone[0...mid].to_i.to_s, i - 1),
        transform(stone[mid...stone.size].to_i.to_s, i - 1)
      ].flatten.sum
    else
      transform((2024 * stone.to_i).to_s, i - 1)
    end
end

puts $stdin.each_line
           .map { |l| l.chomp.split }
           .flatten
           .map { |s| transform(s, 75) }
           .flatten
           .sum
