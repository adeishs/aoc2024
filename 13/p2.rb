#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

BUTTON_RE = Regexp.new('X\+(\d+), Y\+(\d+)')
PRIZE_RE = Regexp.new('X=(\d+), Y=(\d+)')
TOKEN_COSTS = [3, 1].freeze
ADJUSTMENT = 10000000000000

def get_coord(line, regexp, adj)
  Complex(*line.scan(regexp).flatten.map { |c| c.to_i + adj })
end

def parse_machine(str)
  lines = str.split("\n")
  {
    buttons: lines[0..1].map { |b| get_coord(b, BUTTON_RE, 0) },
    prize: get_coord(lines.last, PRIZE_RE, ADJUSTMENT)
  }
end

def parse(inp)
  inp.split("\n\n").map { |machine_str| parse_machine(machine_str) }
end

def play_machine(machine)
  mp = machine[:prize]
  buttons = machine[:buttons]

  a = 1.0 * (mp.real * buttons[1].imag - mp.imag * buttons[1].real) /
    (buttons[0].real * buttons[1].imag - buttons[0].imag * buttons[1].real)
  b = 1.0 * (mp.imag * buttons[0].real - mp.real * buttons[0].imag) /
    (buttons[0].real * buttons[1].imag - buttons[0].imag * buttons[1].real)

  return (3 * a + b).to_i if a == a.to_i && b == b.to_i
  0
end

puts parse($stdin.read).map { |m| play_machine(m) }.sum