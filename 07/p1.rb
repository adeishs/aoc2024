#!/usr/bin/env ruby
# frozen_string_literal: true

OPS = %w[+ *].freeze

def parse(line)
  test, operand_str = line.split(': ')
  operands = operand_str.split.map(&:to_i)

  { test: test.to_i, operands: operands }
end

def alt_found?(operators, equation)
  result = 0
  (['+'] + operators).each.with_index do |o, i|
    result = result.send(o, equation[:operands][i])
  end

  result == equation[:test]
end

def tested?(equation)
  OPS.repeated_permutation(equation[:operands].size - 1)
     .any? { |ops| alt_found?(ops, equation) }
end

puts $stdin.each_line.map { |l| parse(l.chomp) }
           .select { |e| tested?(e) }
           .map { |e| e[:test] }
           .sum
