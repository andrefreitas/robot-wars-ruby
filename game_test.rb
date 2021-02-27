# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'game'

class TestGameEngine < MiniTest::Unit::TestCase
  attr_reader :map, :sampler, :game

  def setup
    @map = {
      'Porto' => { north: 'Braga', south: 'Gaia', west: 'Sea', east: 'Guarda' },
      'Gaia' => { north: 'Porto', south: 'Aveiro' },
      'Aveiro' => { north: 'Gaia' },
      'Braga' => { south: 'Porto' },
      'Sea' => { east: 'Porto' },
      'Guarda' => { west: 'Porto' }
    }

    @sampler = MiniTest::Mock.new
    @sampler.expect :sample, 'Porto', [map.keys]
    @sampler.expect :sample, 'Gaia', [map.keys.reject { |city| city == 'Porto' }]

    @game = Game.new(map, 2, @sampler)
  end

  def test_initialize_more_robots_than_cities
    assert_raises(RuntimeError, 'More robots than cities') { Game.new(map, 7) }
  end

  def test_initialize
    # Test map
    assert_equal map, game.map
    assert_equal 2, game.robots.size

    # Test robots
    assert_equal '1', game.robots[0].name
    assert !game.robots[0].dead?
    assert_equal 'Porto', game.robots[0].city

    assert_equal '2', game.robots[1].name
    assert !game.robots[1].dead?
    assert_equal 'Gaia', game.robots[1].city

    assert_equal 0, game.movements
  end

  def test_move_survive
    @sampler.expect :sample, 'Braga', [map['Porto'].values]
    @sampler.expect :sample, 'Aveiro', [map['Gaia'].values]

    game.move

    assert_equal 'Braga', game.robots[0].city
    assert_equal 'Aveiro', game.robots[1].city
    assert !game.robots[0].dead?
    assert !game.robots[1].dead?

    assert_equal 2, game.movements

    assert game.map.include? 'Braga'
    assert game.map.include? 'Aveiro'
  end

  def test_move_destroy_city
    2.times { @sampler.expect(:sample, 'Braga') { true } }

    updates = game.move

    expected_updates = [
      [:moved, { robot: game.robots[0], city: 'Braga' }],
      [:city_destroyed, { city: 'Braga', robots: [game.robots[1], game.robots[0]] }]
    ]
    assert_equal expected_updates, updates

    assert_equal 'Braga', game.robots[0].city
    assert_equal 'Braga', game.robots[1].city
    assert game.robots[0].dead?
    assert game.robots[1].dead?

    assert_equal 2, game.movements

    assert !game.map.include?('Braga')
    assert !game.map['Porto'].values.include?('Braga')
  end

  def test_move_destroyed_robot_cannot_move
    2.times { @sampler.expect(:sample, 'Braga') { true } }
    game.robots[0].dead = true

    game.move

    assert_equal 'Porto', game.robots[0].city
    assert_equal 'Braga', game.robots[1].city
    assert !game.robots[1].dead?

    assert_equal 1, game.movements
  end

  def test_move_robot_trapped
    # City destroyed
    game.map = {}
    game.move
    assert_equal 0, game.movements

    # No roads
    game.map = { 'Porto' => {}, 'Gaia' => {} }
    game.move
    assert_equal 0, game.movements
  end

  def test_game_over_false
    assert !game.game_over?
  end

  def test_game_over_all_cities_destroyed
    game.map = {}
    assert game.game_over?
  end

  def test_game_over_all_robots_destroyed
    game.robots.each { |r| r.dead = true }
    assert game.game_over?
  end

  def test_game_over_max_movements
    game.movements = Game::MAX_MOVEMENTS
    assert game.game_over?

    game.movements = Game::MAX_MOVEMENTS + 1
    assert game.game_over?
  end
end
