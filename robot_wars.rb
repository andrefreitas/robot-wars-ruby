#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'map_reader'
require_relative 'map_printer'
require_relative 'game'

SLEEP_TIME = 0.2

def print_update(type, context)
  output =
    case type
    when :city_destroyed
      "#{context[:city]} has been destroyed by robot #{context[:robots][0].name} and robot #{context[:robots][1].name}!"
    when :moved
      "Robot #{context[:robot].name} moved to #{context[:city]}"
    end
  puts output
end

def robot_wars(map_path, n_robots)
  map = MapReader.read(map_path)
  game = Game.new(map, n_robots)

  until game.game_over?
    game.move.each { |update| print_update(*update) }
    sleep(SLEEP_TIME)
  end

  puts MapPrinter.print(game.map)
end

map_path, n_robots = ARGV
robot_wars(map_path, n_robots.to_i)
