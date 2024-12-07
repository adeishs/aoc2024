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

def tested?(equation)
  OPS.repeated_permutation(equation[:operands].size - 1)
     .any? { |ops| alt_found?(ops, equation) }
end

puts $stdin.each_line.map { |l| parse(l.chomp) }
           .select { |e| tested?(e) }
           .map { |e| e[:test] }
           .sum
