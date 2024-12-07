#!/usr/bin/env ruby
# frozen_string_literal: true

OPS = %w[+ * |].freeze

def parse(line)
  test, operand_str = line.split(': ')
  operands = operand_str.split.map(&:to_i)

  { test: test.to_i, operands: operands }
end

def calculate(operators, equation)
  result = 0
  (['+'] + operators).each.with_index do |o, i|
    result = if o == '|'
               "#{result}#{equation[:operands][i]}".to_i
             else
               result.send(o, equation[:operands][i])
             end
  end

  result
end

def tested?(equation)
  OPS.repeated_permutation(equation[:operands].size - 1)
     .each do |ops|
       return true if equation[:test] == calculate(ops, equation)
     end

  false
end

puts $stdin.each_line.map { |l| parse(l.chomp) }
           .select { |e| tested?(e) }
           .map { |e| e[:test] }
           .sum
