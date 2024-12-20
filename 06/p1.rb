#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

START = '^'
OBST = { '#' => true }.freeze

def find_start(rows)
  rows.map.with_index { |row, r| [r, row.index(START)] }
      .reject { |_, x| x.nil? }
      .map { |y, x| Complex(x, y) }
      .first
end

def move(rows, curr_pos, dir)
  new_pos = curr_pos + dir
  return nil unless new_pos.imag.between?(0, rows.size - 1) &&
                    new_pos.real.between?(0, rows.first.size - 1)

  if OBST[rows[new_pos.imag][new_pos.real]]
    dir *= 0 + 1i
  else
    curr_pos += dir
  end
  [curr_pos, dir]
end

def run_guard(rows)
  curr_pos = find_start(rows)
  visiteds = Set.new
  dir = 0 + -1i
  while curr_pos
    visiteds << curr_pos
    curr_pos, dir = move(rows, curr_pos, dir)
  end

  visiteds.size
end

puts run_guard($stdin.each_line.map(&:chomp))
