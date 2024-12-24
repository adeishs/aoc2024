#!/usr/bin/env ruby
# frozen_string_literal: true

OP_MAP = {
  'AND' => '&',
  'OR' => '|',
  'XOR' => '^'
}.freeze

def parse(input)
  init_str, gates_str = input.split("\n\n")

  wire_val = init_str.split("\n")
                     .each_with_object(Hash.new { |h, k| h[k] = nil }) do |l, o|
                       wire, val = l.split(': ')
                       o[wire] = val.to_i
                     end

  gate_ops = gates_str.split("\n")
                      .each_with_object([]) do |l, o|
                        operation, output = l.split(' -> ')
                        operand1, operator, operand2 = operation.split(' ')
                        o << [
                          wire_val[operand1] || operand1,
                          OP_MAP[operator],
                          wire_val[operand2] || operand2,
                          output
                        ]
                      end

  { wire_val: wire_val.reject { |_, v| v.nil? }, gate_ops: gate_ops }
end

def run(prog)
  until prog[:gate_ops].empty?
    gos = prog[:gate_ops].shift
    if gos[0].is_a?(Integer) && gos[2].is_a?(Integer)
      prog[:wire_val][gos[3]] = gos[0].send(gos[1], gos[2])
    else
      [0, 2].each do |i|
        gos[i] = prog[:wire_val][gos[i]] unless prog[:wire_val][gos[i]].nil?
      end
      prog[:gate_ops] << gos
    end
  end

  prog[:wire_val].map { |w, v| w[0] == 'z' ? v << w[1..].to_i : 0 }
                 .reduce(0, :|)
end

puts run(parse($stdin.read))
