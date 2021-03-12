# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'map_printer'

EXPECTED_OUTPUT = %(Porto north=Braga south=Gaia west=Sea east=Guarda
Gaia north=Porto south=Aveiro
Aveiro north=Gaia
Braga south=Porto
Sea east=Porto
Guarda west=Porto)

class TestMapPrinter < MiniTest::Test
  def test_print_empty
    assert_equal '', MapPrinter.print({})
  end

  def test_print_with_cities
    map = {
      'Porto' => { north: 'Braga', south: 'Gaia', west: 'Sea', east: 'Guarda' },
      'Gaia' => { north: 'Porto', south: 'Aveiro' },
      'Aveiro' => { north: 'Gaia' },
      'Braga' => { south: 'Porto' },
      'Sea' => { east: 'Porto' },
      'Guarda' => { west: 'Porto' }
    }
    output = MapPrinter.print(map)

    assert_equal EXPECTED_OUTPUT, output
  end
end
