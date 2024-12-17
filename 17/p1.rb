#!/usr/bin/env ruby
# frozen_string_literal: true

REG_RE = Regexp.new('([ABC]): (\d+)')
CO_REG_MAP = {
  4 => 'A',
  5 => 'B',
  6 => 'C'
}.freeze
DV_REG_MAP = {
  0 => 'A',
  6 => 'B',
  7 => 'C'
}.freeze

def parse(inp)
  reg_str, prog_str = inp.split("\n\n")

  reg_vals = *reg_str.each_line
                     .map { |l| l.scan(REG_RE).flatten }
                     .flat_map { |r, v| [r, v.to_i] }

  {
    reg: Hash[*reg_vals],
    ops: prog_str.split(' ').last.split(',').map(&:to_i)
  }
end

def get_co_val(combo_op, reg)
  rm = CO_REG_MAP[combo_op]
  rm.nil? ? combo_op : reg[rm]
end

def regdv(reg, operand)
  reg['A'] / (1 << get_co_val(operand, reg))
end

def run(prog)
  out_vals = []
  i = 0
  while i < prog[:ops].size
    opcode, operand = prog[:ops][i..i + 1]

    case opcode
    when 1
      prog[:reg]['B'] ^= operand

    when 2
      prog[:reg]['B'] = get_co_val(operand, prog[:reg]) % 8

    when 3
      i = operand - 2 unless prog[:reg]['A'].zero?

    when 4
      prog[:reg]['B'] ^= prog[:reg]['C']

    when 5
      out_vals.append(get_co_val(operand, prog[:reg]) % 8)

    else
      prog[:reg][DV_REG_MAP[opcode]] = regdv(prog[:reg], operand)
    end

    i += 2
  end

  out_vals
end

puts run(parse($stdin.read)).join(',')
