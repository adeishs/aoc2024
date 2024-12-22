#!/usr/bin/env ruby
# frozen_string_literal: true

def mix_rinse(num, shl)
  ((num << shl) ^ num) & 0xffffff
end

def get_next_secret_num(num)
  mix_rinse(mix_rinse(mix_rinse(num, 6), -5), 11)
end

def get_prices(num)
  prices = []
  diffs = []
  prev = 0
  2000.times do
    lsd = num % 10
    prices << lsd
    diffs << lsd - prev
    prev = lsd
    num = get_next_secret_num(num)
  end

  seq_price = {}
  diffs[1..].each_cons(4).with_index do |seq, i|
    seq_price[seq] ||= prices[i + 4]
  end

  seq_price
end

seq_prices = $stdin.each_line.map { |c| get_prices(c.to_i) }
seqs = seq_prices.map(&:keys).reduce(&:concat).uniq
puts seqs.map { |s| seq_prices.sum { |p| p[s] || 0 } }.max
