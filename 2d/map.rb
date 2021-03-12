require 'ruby2d'
require_relative '../map_reader'

DEFAULT_MAP_PATH = 'world_map_small.txt'.freeze

class Map
  attr_reader :map

  CITY_DIMENSION = 200

  def initialize(map_path = DEFAULT_MAP_PATH)
    @map = load_map(map_path)
  end

  def draw
    map.each do |city, coordinates|
      draw_city(city, coordinates)
    end
  end

  def width
    (map.values.map { |c| c[:x] }.max + 1) * CITY_DIMENSION
  end

  def height
    (map.values.map { |c| c[:y] }.max + 1) * CITY_DIMENSION
  end

  private

  def load_map(map_path)
    map = MapReader.read(map_path)
    MapReader.to_coordinates(map)
  end

  def draw_city(city, coordinates)
    x = coordinates[:x] * CITY_DIMENSION
    y = coordinates[:y] * CITY_DIMENSION

    Square.new(
      x: x,
      y: y,
      size: CITY_DIMENSION,
      color: 'blue'
    )

    Text.new(
      city,
      size: 12,
      x: x,
      y: y
    )
  end
end
