#!/usr/bin/env ruby
# frozen_string_literal: true

REVERSE = { '^' => 'v', 'v' => '^', '<' => '>', '>' => '<' }.freeze

NUMPAD_U_MVT = { 'A0' => '<' }.merge(
  Hash[
    *(
      # A1–A9
      [*1..9].flat_map do |t|
        u = (t + 2) / 3
        ["A#{t}", (['^'] * u + (['<'] * (3 * u - t))).join]
      end +
      # 01–09
      [*1..9].flat_map do |t|
        u = (t + 2) / 3
        l = 3 * u - t - 1
        ["0#{t}", (['^'] * u + (l.positive? ? (['<'] * l) : (['>'] * -l))).join]
      end +
      # 12–19, 45–49, 78, 79
      [*2..9].flat_map do |t|
        ms = []
        [1, 4, 7].each do |s|
          if t > s
            u = (t - s) / 3
            ms += ["#{s}#{t}", ((['>'] * ((t + 2) % 3)) + ['^'] * u).join]
          end
        end

        ms
      end +
      # 23–29, 56–59, 88, 99
      [*3..9].flat_map do |t|
        ms = []
        [2, 5, 8].each do |s|
          next unless t > s

          u = (t + 1 - s) / 3
          l = (t % 3).zero? ? -1 : (2 - (t % 3))
          ms += [
            "#{s}#{t}",
            ((l.positive? ? (['<'] * l) : (['>'] * -l)) + ['^'] * u).join
          ]
        end

        ms
      end +
      # 34–39, 67–69
      [*4..9].flat_map do |t|
        ms = []
        [3, 6, 9].each do |s|
          next unless t > s

          u = (t - s + 2) / 3
          ms += [
            "#{s}#{t}",
            ((['<'] * ((t % 3).zero? ? 0 : 3 - (t % 3))) + ['^'] * u).join
          ]
        end

        ms
      end
    )
  ]
).freeze

NUMPAD_MVT = NUMPAD_U_MVT.merge(
  Hash[
    *NUMPAD_U_MVT.flat_map do |k, v|
      [k.reverse, v.reverse.chars.map { |m| REVERSE[m] }.join]
    end
  ]
).freeze

#   ^ A
# < v >
DIRPAD_D_MVT = {
  'AA' => '',
  '^^' => '',
  '<<' => '',
  'vv' => '',
  '>>' => '',
  'A^' => '<',
  'A<' => 'v<<',
  'Av' => '<v',
  'A>' => 'v',
  '^<' => 'v<',
  '^v' => 'v',
  '^>' => '>v',
  '><' => '<<',
  '>v' => '<',
  'v<' => '<'
}.freeze
DIRPAD_MVT = DIRPAD_D_MVT.merge(
  Hash[
    *DIRPAD_D_MVT.flat_map do |k, v|
      [k.reverse, v.reverse.chars.map { |m| REVERSE[m] }.join]
    end
  ]
)

def solve_mvt(code, numpad_mvt)
  end_locs = code.chars
  start_locs = end_locs.rotate(-1)
  path_locs = []

  until end_locs.empty?
    end_loc = end_locs.shift
    start_loc = start_locs.shift

    path_locs += [numpad_mvt["#{start_loc}#{end_loc}"]] + ['A']
  end

  path_locs.join
end

def solve(code)
  num = code[0...-1].to_i
  code = solve_mvt(code, NUMPAD_MVT)
  2.times { code = solve_mvt(code, DIRPAD_MVT) }
  code.size * num
end

puts $stdin.each_line.map { |c| solve(c.chomp) }.sum
