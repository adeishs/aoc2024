#!/usr/bin/env ruby
# frozen_string_literal: true

ROBOT_RE = Regexp.new('^p=(\d+),(\d+) v=(-?\d+),(-?\d+)$')
SPACE_DIM = 101 + 103i
MID_POINT = Complex(SPACE_DIM.real / 2, SPACE_DIM.imag / 2)
CELL = { false => '.', true => '#' }.freeze

def parse_robot(line)
  nums = line.scan(ROBOT_RE).flatten.map(&:to_i)
  {
    p: Complex(*nums.shift(2)),
    v: Complex(
      *nums.shift(2)
           .zip([SPACE_DIM.real, SPACE_DIM.imag])
           .map { |ns| ns.sum % ns.last }
    )
  }
end

def get_robot_grid(cnt)
  (0...SPACE_DIM.imag).map do |y|
    (
      (0...SPACE_DIM.real).map { |x| CELL[cnt[Complex(x, y)].positive?] } +
        ["\n"]
    ).join
  end
end

robots = $stdin.each_line.map { |l| parse_robot(l.chomp) }
(1..10_000).each do |s|
  robot_cnt = Hash.new(0)

  found = true
  robots.each do |robot|
    loc = robot[:p] + s * robot[:v]
    new_loc = Complex(loc.real % SPACE_DIM.real, loc.imag % SPACE_DIM.imag)
    robot_cnt[new_loc] += 1
    if robot_cnt[new_loc] > 1
      found = false
      break
    end
  end

  next unless found

  puts get_robot_grid(robot_cnt)
  puts s
  break
end
