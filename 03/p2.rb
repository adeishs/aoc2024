#!/usr/bin/env ruby
# frozen_string_literal: true

def get_tokens(line)
  line.scan(/((mul)\((\d+),(\d+)\)|do\(\)|don't\(\))/)
      .map do |els|
        op, _, *args = els
        op.start_with?('m') ? ['m', *args] : [op[0...op.size - 2]]
      end
end

def parse_token(tokens, exec_flag)
  op, *args = tokens
  return [0, op == 'do'] if op != 'm'
  return [0, exec_flag] unless exec_flag

  [args.map(&:to_i).reduce(:*), exec_flag]
end

def parse(line)
  f = true
  get_tokens(line).map do |t|
    m, f = parse_token(t, f)
    m
  end
end

puts parse($stdin.each_line.map(&:chomp).join).sum
