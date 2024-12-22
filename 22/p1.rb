#!/usr/bin/env ruby
# frozen_string_literal: true

def get_next_secret_num(num)
  num = ((num << 6) ^ num) & 0xffffff
  num = ((num >> 5) ^ num) & 0xffffff
  ((num << 11) ^ num) & 0xffffff
end

def get_final_secret_num(num)
  2000.times { num = get_next_secret_num(num) }
  num
end

puts $stdin.each_line.map { |c| get_final_secret_num(c.to_i) }.sum
