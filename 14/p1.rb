#!/usr/bin/env ruby
# frozen_string_literal: true

ROBOT_RE = Regexp.new('^p=(\d+),(\d+) v=(-?\d+),(-?\d+)$')
SPACE_DIM = 101 + 103i
MID_POINT = Complex(SPACE_DIM.real / 2, SPACE_DIM.imag / 2)

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

def get_quadrant(loc)
  return nil if %w[imag real].any? { |m| loc.send(m) == MID_POINT.send(m) }

  (loc.imag < MID_POINT.imag ? 0 : 2) + (loc.real < MID_POINT.real ? 0 : 1)
end

robots = $stdin.each_line.map { |l| parse_robot(l.chomp) }
robot_cnt =
  robots.each_with_object(Hash.new(0)) do |robot, o|
    loc = robot[:p] + 100 * robot[:v]
    o[Complex(loc.real % SPACE_DIM.real, loc.imag % SPACE_DIM.imag)] += 1
  end

quadrant_cnts =
  robot_cnt.keys.each_with_object(Array.new(4, 0)) do |loc, cnts|
    q = get_quadrant(loc)
    cnts[q] += robot_cnt[loc] unless q.nil?
  end

puts quadrant_cnts.reduce(1, :*)
