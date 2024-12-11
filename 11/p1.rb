#!/usr/bin/env ruby
# frozen_string_literal: true

def transform(stone)
  if stone == '0'
    '1'
  elsif stone.size.even?
    mid = stone.size / 2
    [stone[0...mid].to_i.to_s, stone[mid...stone.size].to_i.to_s]
  else
    (2024 * stone.to_i).to_s
  end
end

def blink(stones)
  stones.map { |s| transform(s) }.flatten
end

stones = $stdin.each_line
               .map { |l| l.chomp.split }
               .flatten
25.times { stones = blink(stones) }
puts stones.size
