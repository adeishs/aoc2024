#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def parse_input(inp)
  ord_rules_str, updates_str = inp.split("\n\n")

  post, pre =
    ord_rules_str.split
                 .map { |r| r.chomp.split('|').map(&:to_i) }
                 .each_with_object([{}, {}]) do |els, os|
                   pred, succ = els
                   os.first[pred] ||= Set.new
                   os.first[pred] << succ
                   os.last[succ] ||= Set.new
                   os.last[succ] << pred
                 end
  updates = updates_str.split.map { |u| u.chomp.split(',').map(&:to_i) }
  [post, pre, updates]
end

def correct?(post, pre, pages)
  pages.each.with_index do |page, i|
    return false unless pages[0...i].all? do |l|
                          pre[page]&.member?(l)
                        end &&
                        pages[i + 1...pages.size].all? do |l|
                          post[page]&.member?(l)
                        end
  end

  true
end

def correct_order(post, updates)
  swap_pages = lambda { |i, j|
    updates[j], updates[i] = updates[i], updates[j]
  }
  (0...updates.size - 1).each do |i|
    (i + 1...updates.size).each do |j|
      next unless post[updates[i]]&.member?(updates[j])

      swap_pages.call(i, j)
    end
  end

  updates
end

def incorrect_mids(post, pre, updates)
  updates.reject { |u| correct?(post, pre, u) }
         .map { |pages| correct_order(post, pages)[pages.size / 2] }
end

puts incorrect_mids(*parse_input($stdin.read)).sum
