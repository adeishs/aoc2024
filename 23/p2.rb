#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

# Bron–Kerbosch algorithm
def find_cliques(conn, r, p, x, cliques)
  if p.empty? && x.empty?
    cliques << r.sort if r.size > 2
    return
  end

  p.to_a.each do |v|
    find_cliques(conn, r | Set[v], p & conn[v], x & conn[v], cliques)
    p -= Set[v]
    x << v
  end
end

conn = $stdin.each_line
             .each_with_object(Hash.new { |h, k| h[k] = Set.new }) do |l, o|
               c1, c2 = l.chomp.split('-')
               o[c1] << c2
               o[c2] << c1
             end

cliques = []
find_cliques(conn, Set.new, conn.keys.to_set, Set.new, cliques)
puts cliques.max { |a, b| a.size <=> b.size }.join(',')
