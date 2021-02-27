# frozen_string_literal: true

class MapReader
  def self.read(file_path)
    File.read(file_path).lines.map do |line|
      city, *directions = line.split
      directions = directions
                   .map { |pair| pair.split('=') }
                   .map { |direction, next_city| [direction.to_sym, next_city] }
                   .to_h

      [city, directions]
    end.to_h
  end
end
