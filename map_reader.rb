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

  def self.shift_axis_delta(coordinates, axis)
    (coordinates.values.map { |c| c[axis] }.filter(&:negative?).min || 0).abs
  end

  def self.to_coordinates(map)
    coordinates = compute_coordinates(map, map.keys.first)

    delta_x = shift_axis_delta(coordinates, :x)
    delta_y = shift_axis_delta(coordinates, :y)
    return coordinates if delta_x.zero? && delta_y.zero?

    coordinates.each do |_city, pair|
      pair[:x] += delta_x unless delta_x.zero?
      pair[:y] += delta_y unless delta_y.zero?
    end
  end

  def self.compute_position(position, direction)
    position.clone.tap do |next_position|
      case direction
      when :north
        next_position[:y] -= 1
      when :south
        next_position[:y] += 1
      when :west
        next_position[:x] -= 1
      when :east
        next_position[:x] += 1
      end
    end
  end

  def self.compute_coordinates(map, city, coordinates = {}, position = { x: 0, y: 0 })
    coordinates[city] = position

    map[city].each do |direction, next_city|
      next if coordinates.include? next_city

      next_position = compute_position(position, direction)
      compute_coordinates(map, next_city, coordinates, next_position)
    end

    coordinates
  end
end
