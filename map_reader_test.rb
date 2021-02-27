# frozen_string_literal: true

require 'tempfile'
require 'minitest/autorun'
require_relative 'map_reader'

class TestMapReader < MiniTest::Unit::TestCase
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
end
