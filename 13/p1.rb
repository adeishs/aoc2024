#!/usr/bin/env ruby
# frozen_string_literal: true

BUTTON_RE = Regexp.new('X\+(\d+), Y\+(\d+)')
PRIZE_RE = Regexp.new('X=(\d+), Y=(\d+)')
TOKEN_COSTS = [3, 1].freeze

def get_coord(line, regexp)
  Complex(*line.scan(regexp).flatten.map(&:to_i))
end

def parse_machine(str)
  lines = str.split("\n")
  {
    buttons: lines[0..1].map { |b| get_coord(b, BUTTON_RE) },
    prize: get_coord(lines.last, PRIZE_RE)
  }
end

def parse(inp)
  inp.split("\n\n").map { |machine_str| parse_machine(machine_str) }
end

def play_machine(machine)
  mp = machine[:prize]
  buttons = machine[:buttons]

  # use Cramer’s rule
  det = buttons[0].real * buttons[1].imag - buttons[0].imag * buttons[1].real

  sols = [
    mp.real * buttons[1].imag - mp.imag * buttons[1].real,
    buttons[0].real * mp.imag - buttons[0].imag * mp.real
  ].map { |s| s.to_f / det }

  # accept only round-number solutions
  return 0 if sols.any? { |s| s != s.to_i }

  TOKEN_COSTS.zip(sols.map(&:to_i)).map { |fs| fs.reduce(1, :*) }.sum
end

puts parse($stdin.read).map { |m| play_machine(m) }.sum
