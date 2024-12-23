#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

conn = $stdin.each_line
             .each_with_object(Hash.new { |h, k| h[k] = Set.new }) do |l, o|
               c1, c2 = l.chomp.split('-')
               o[c1] << c2
               o[c2] << c1
             end

sets =
  conn.keys.flat_map do |c1|
    conn[c1].flat_map do |c2|
      conn[c2].select do |c3|
        conn[c1].member?(c3) &&
          [c1, c2, c3].any? { |c| c[0] == 't' }
      end.map do |c3|
        [c1, c2, c3].sort
      end
    end
  end.uniq

puts sets.size
