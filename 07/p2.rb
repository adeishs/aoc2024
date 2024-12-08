#!/usr/bin/env ruby
# frozen_string_literal: true

OPS = %w[+ * |].freeze

def parse(line)
  test, operand_str = line.split(': ')
  operands = operand_str.split.map(&:to_i)

  { test: test.to_i, operands: operands }
end

def calc(acc, ops)
  operator, operand = ops
  return "#{acc}#{operand}".to_i if operator == '|'

  acc.send(operator, operand)
end

def alt_found?(operators, equation)
  equation[:test] ==
    (['+'] + operators).zip(equation[:operands])
                       .reduce(0) { |test, ops| calc(test, ops) }
end

def test(equation)
  return 0 if OPS.repeated_permutation(equation[:operands].size - 1)
                 .none? { |ops| alt_found?(ops, equation) }

  equation[:test]
end

puts $stdin.each_line
           .map { |l| test(parse(l.chomp)) }
           .sum
