#!/usr/bin/env ruby
# frozen_string_literal: true

F = {
  'do()' => true,
  "don't()" => false
}.freeze

def get_tokens(line)
  line.scan(/(mul\(\d+,\d+\)|do\(\)|don't\(\))/).flatten
end

def parse_token(token, factor)
  return [0, F[token]] unless token.start_with?('m')
  return [0, factor] unless factor

  [token.scan(/\d+/).map(&:to_i).reduce(:*), factor]
end

def parse(line)
  f = true
  get_tokens(line).map do |t|
    m, f = parse_token(t, f)
    m
  end
end

puts parse($stdin.each_line.map(&:chomp).join).sum
