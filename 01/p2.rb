#!/usr/bin/env ruby
# frozen_string_literal: true

lefts, freq = $stdin.each_line
                    .map { |line| line.chomp.split.map(&:to_i) }
                    .each_with_object([[], Hash.new(0)]) do |els, os|
                      os.first << els.shift
                      os.last[els.shift] += 1
                    end

puts lefts.map { |l| l * freq[l] }.sum
