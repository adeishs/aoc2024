#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

START = '^'
OBST_TILE = '#'
OBST = { OBST_TILE => true }.freeze

def find_start(rows)
  rows.map.with_index { |row, r| [r, row.index(START)] }
      .reject { |_, x| x.nil? }
      .map { |y, x| Complex(x, y) }
      .first
end

def put_obst(rows, pos)
  rows.map.with_index do |row, r|
    if r == pos.imag
      "#{row[0...pos.real]}#{OBST_TILE}#{row[pos.real + 1...row.size]}"
    else
      row
    end
  end
end

def has_loop?(rows, curr_pos)
  visiteds = Set.new
  dir = 0 + -1i
  loop do
    return true if visiteds.member?([curr_pos, dir])
    visiteds << [curr_pos, dir]
    new_pos = curr_pos + dir
    break unless new_pos.imag.between?(0, rows.size - 1) &&
                 new_pos.real.between?(0, rows.first.size - 1)

    if OBST[rows[new_pos.imag][new_pos.real]]
      dir *= 0 + 1i
    else
      curr_pos += dir
    end
  end

  false
end

def get_possible_loop_count(rows)
  start_pos = find_start(rows)
  [*0...rows.size].product([*0...rows.first.size])
                  .select do |y, x|
                    has_loop?(put_obst(rows, Complex(x, y)), start_pos)
                  end.size
end

puts get_possible_loop_count($stdin.each_line.map(&:chomp))
