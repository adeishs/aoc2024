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
  # init value obtained by manual observation of the first output values
  # First  1 matched if init value is                                    1
  # First  2 matched if init value is                           1100001001
  # First  3 matched if init value is                           1100001001
  # First  4 matched if init value is                         100010011011
  # First  5 matched if init value is                     1111001100001001
  # First  6 matched if init value is               1100100010100110011010
  # First  7 matched if init value is               1100100010100110011010
  # First  8 matched if init value is           10001110001000100110011010
  # First  9 matched if init value is           10001110001000100110011010
  # First 10 matched if init value is   1001001011101010011000100110011010
  # First 11 matched if init value is 101001001011101010011000100110011010
  # and so on. We use the init value from 10 as it’s fast enough already
  # to be used as a starting point to reach all matches
  a = 0b1001001011101010011000100110011010
  matched = false
  reg = prog[:reg]
  ops = prog[:ops]
  until matched
    reg['A'] = a
    out_vals = []
    i = 0
    while i < ops.size
      opcode, operand = ops[i..i + 1]

      case opcode
      when 1
        reg['B'] ^= operand

      when 2
        reg['B'] = get_co_val(operand, reg) % 8

      when 3
        i = operand - 2 unless reg['A'].zero?

      when 4
        reg['B'] ^= reg['C']

      when 5
        out_vals.append(get_co_val(operand, reg) % 8)
        m = out_vals.size - 1

        break if out_vals[m] != ops[m]

        if m == ops.size - 1
          matched = true
          break
        end
      else
        reg[DV_REG_MAP[opcode]] = regdv(reg, operand)
      end

      i += 2
    end

    # do not touch LSBs
    a += 0b10000000000000000000000000000000000 unless matched
  end

  a
end

puts run(parse($stdin.read))
