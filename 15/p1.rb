#!/usr/bin/env ruby
# frozen_string_literal: true

ROBOT = '@'
BOX = 'O'
WALL = '#'
EMPTY = '.'
DIR = {
  '^' => 0 + -1i,
  'v' => 0 + 1i,
  '>' => 1 + 0i,
  '<' => -1 + 0i
}.freeze

def update_tile(rows, loc, tile)
  rx, ry = loc.rect
  rr = rows[ry]

  rows[0...ry] +
    ["#{rr[0...rx]}#{tile}#{rr[rx + 1...rr.size]}"] +
    rows[ry + 1...rows.size]
end

def parse_input(inp)
  map_str, mvt_str = inp.split("\n\n")

  rows = map_str.split("\n")[1...-1].map { |r| r[1...-1] }
  init_loc = Complex(
    *rows.map.with_index { |row, y| [row.index(ROBOT), y] }
         .reject { |cs| cs.first.nil? }
         .flatten
  )

  {
    init_loc: init_loc,
    rows: update_tile(rows, init_loc, EMPTY),
    mvts: mvt_str.chars.each_with_object([]) do |m, ds|
            d = DIR[m]
            ds << d unless d.nil?
          end
  }
end

def in_map?(loc, max_loc)
  loc.rect.zip(max_loc.rect).all? { |l, m| l.between?(0, m) }
end

def obj_at?(rows, loc, obj)
  rows[loc.imag][loc.real] == obj
end

def move_box(rows, loc, dir, max_loc)
  nl = loc + dir
  # no-op if hitting a wall
  return [loc, rows] if !in_map?(nl, max_loc) || obj_at?(rows, nl, WALL)

  empty_found = false
  empty_loc = nl
  until empty_found
    break if !in_map?(empty_loc, max_loc) || obj_at?(rows, empty_loc, WALL)

    if obj_at?(rows, empty_loc, EMPTY)
      empty_found = true
    else
      empty_loc += dir
    end
  end

  if empty_found
    rows = update_tile(rows, empty_loc, BOX)
    rows = update_tile(rows, nl, EMPTY)
    return [nl, rows]
  end

  [loc, rows]
end

def move_robot(loc, dir, rows, max_loc)
  nl = loc + dir
  # no-op if hitting a wall
  return [loc, rows] if !in_map?(nl, max_loc) || obj_at?(rows, nl, WALL)

  # move and nothing else if empty
  return [nl, rows] if obj_at?(rows, nl, EMPTY)

  move_box(rows, loc, dir, max_loc)
end

def run_warehouse(warehouse)
  loc = warehouse[:init_loc]
  rows = warehouse[:rows]
  max_loc = Complex(rows.first.size - 1, rows.size - 1)

  warehouse[:mvts].each { |d| loc, rows = move_robot(loc, d, rows, max_loc) }
  rows
end

def calc_row_gps_sum(row, idx)
  row.chars
     .map.with_index { |t, x| t == BOX ? (100 * (idx + 1) + x + 1) : 0 }.sum
end

puts run_warehouse(
  parse_input($stdin.read)
).map.with_index { |row, y| calc_row_gps_sum(row, y) }.sum
