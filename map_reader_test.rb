# frozen_string_literal: true

require 'tempfile'
require 'minitest/autorun'
require_relative 'map_reader'

class TestMapReader < MiniTest::Test
  def test_read_small_map
    map = MapReader.read('world_map_small.txt')
    assert_equal(
      {
        north: 'Käänli',
        south: 'Tise',
        east: 'Tentottattahkis',
        west: 'Asta'
      },
      map['Äräättitömäs']
    )

    assert_equal(map['Tiitoo'], { north: 'Ela', east: 'Ettipehäneen' })
    assert_equal(map.size, 28)
  end

  def test_read_empty_map
    file = Tempfile.new('empty.txt')
    assert_equal({}, MapReader.read(file.path))
  end

  def test_to_coordinates
    map = {
      'Porto' => { north: 'Braga', south: 'Gaia', west: 'Matosinhos', east: 'Guarda' },
      'Gaia' => { north: 'Porto', south: 'Aveiro' },
      'Aveiro' => { north: 'Gaia' },
      'Braga' => { south: 'Porto' },
      'Matosinhos' => { east: 'Porto' },
      'Guarda' => { west: 'Porto' }
    }

    coordinates = MapReader.to_coordinates(map)
    expected_coordinates = {
      'Porto' => { x: 1, y: 1 },
      'Braga' => { x: 1, y: 0 },
      'Gaia' => { x: 1, y: 2 },
      'Aveiro' => { x: 1, y: 3 },
      'Matosinhos' => { x: 0, y: 1 },
      'Guarda' => { x: 2, y: 1 }
    }

    assert_equal expected_coordinates, coordinates
  end

  def test_to_coordinates_no_shift
    map = {
      'Porto' => { east: 'Guarda' },
      'Guarda' => { west: 'Porto' }
    }

    coordinates = MapReader.to_coordinates(map)
    expected_coordinates = {
      'Porto' => { x: 0, y: 0 },
      'Guarda' => { x: 1, y: 0 }
    }

    assert_equal expected_coordinates, coordinates
  end
end
