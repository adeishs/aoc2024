#!/usr/bin/env ruby
# frozen_string_literal: true

class BlockFile
  attr_accessor :id, :sz

  def initialize(id, sz)
    @id = id
    @sz = sz
  end
end

def construct_files(disk_map)
  disk_map.chars
          .map
          .with_index { |rep, i| BlockFile.new(i.odd? ? nil : i / 2, rep.to_i) }
          .flatten
          .reject { |f| f.sz.zero? }
end

def expand_files(files)
  files.map { |f| [f.id || 0] * f.sz }.flatten
end

def compact_nils(files)
  compacted_files = [files.first]
  (1...files.size).each do |i|
    if files[i].id.nil? && files[i - 1].id.nil?
      f = compacted_files.pop
      f.sz += files[i].sz
      compacted_files << f
    else
      compacted_files << files[i]
    end
  end

  compacted_files
end

def compact_blocks(disk_map)
  files = construct_files(disk_map)
  file_id = disk_map.size / 2

  files.pop if files.last.id.nil?
  while file_id.positive?
    file_idx = files.rindex { |f| !f.id.nil? && f.id == file_id }
    gap_idx = files[1...files.size].find_index do |f|
      f.id.nil? && f.sz >= files[file_idx].sz
    end
    if (gap_idx || files.size) < file_idx
      gap_idx += 1

      files[file_idx].id = nil
      gap_size = files[gap_idx].sz

      files = compact_nils(
        files[0...gap_idx] +
        [BlockFile.new(file_id, files[file_idx].sz)] +
        if gap_size == files[file_idx].sz
          []
        else
          [BlockFile.new(nil, gap_size - files[file_idx].sz)]
        end +
        files[gap_idx + 1...files.size]
      )
    end

    file_id -= 1
  end

  files
end

def calc_checksum(disk_map)
  expand_files(compact_blocks(disk_map)).map
                                        .with_index { |b, i| b * i }
                                        .sum
end

puts calc_checksum($stdin.each_line.map(&:chomp).first)
