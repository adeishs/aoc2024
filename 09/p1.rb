#!/usr/bin/env ruby
# frozen_string_literal: true

def construct_blocks(disk_map)
  disk_map.chars
          .map
          .with_index { |rep, i| [i.odd? ? nil : i / 2] * rep.to_i }
          .flatten
end

def compact_blocks(blocks)
  max = blocks.size - 1
  new_blocks = []
  blocks.each
        .with_index do |id, i|
    new_blocks << if id.nil?
                    max -= 1 while blocks[max].nil?
                    max -= 1
                    blocks[max + 1]
                  else
                    id
                  end

    break if i == max
  end

  new_blocks
end

def calc_checksum(blocks)
  blocks.map.with_index { |b, i| b * i }.sum
end

puts calc_checksum(
  compact_blocks(
    $stdin.each_line.map { |l| construct_blocks(l.chomp) }
                    .flatten
  )
)
