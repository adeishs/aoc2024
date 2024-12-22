#!/usr/bin/env ruby
# frozen_string_literal: true

def mix_rinse(num, shl)
  ((num << shl) ^ num) & 0xffffff
end

def get_next_secret_num(num)
  mix_rinse(mix_rinse(mix_rinse(num, 6), -5), 11)
end

def get_final_secret_num(num)
  2000.times { num = get_next_secret_num(num) }
  num
end

puts $stdin.each_line.map { |c| get_final_secret_num(c.to_i) }.sum
