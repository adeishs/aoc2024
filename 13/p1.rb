#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

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

def cmp(button, prize)
  if button.real == prize.real
    button.imag <=> prize.imag
  else
    button.real <=> prize.real
  end
end

def calc_token_cost(num_of_presses)
  num_of_presses.zip(TOKEN_COSTS).map { |fs| fs.reduce(1, :*) }.sum
end

def play_machine(machine)
  mp = machine[:prize]
  buttons = machine[:buttons]

  [*0..100].repeated_permutation(2)
           .each do |ns|
             c = cmp(ns.zip(buttons).map { |fs| fs.reduce(1, :*) }.sum, mp)

             return calc_token_cost(ns) if c.zero?
             next if c.positive?
           end

  0
end

puts parse($stdin.read).map { |m| play_machine(m) }.sum
