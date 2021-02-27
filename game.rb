# frozen_string_literal: true

require 'set'

class Robot
  attr_accessor :name, :city, :dead
  alias :dead? dead

  def initialize(name, city)
    @name = name
    @city = city
    @dead = false
  end
end

class RandomSampler
  def self.sample(array)
    array.sample
  end
end

class Game
  MAX_MOVEMENTS = 10_000

  attr_accessor :map, :robots, :movements, :sampler

  def initialize(map, n_robots, sampler = RandomSampler)
    raise 'More robots than cities' if n_robots > map.size

    @sampler = sampler
    @map = map
    @movements = 0
    spawn_robots(n_robots)
  end

  def move
    updates = []

    robots.map do |robot|
      next unless move?(robot)

      next_city = pick_city(robot)
      next_city_robot = robots.find { |r| r.city == next_city }

      if next_city_robot
        robot.dead = true
        next_city_robot.dead = true
        destroy_city(next_city)
        updates << update_destroy(next_city, [robot, next_city_robot])
      else
        updates << update_move(robot, next_city)
      end

      robot.city = next_city
      @movements += 1
    end

    updates
  end

  def game_over?
    map.empty? || movements >= MAX_MOVEMENTS || robots.all?(&:dead?)
  end

  private

  def move?(robot)
    !(robot.dead? || map[robot.city].nil? || map[robot.city].empty?)
  end

  def pick_city(robot)
    sampler.sample(map[robot.city].values)
  end

  def update_destroy(city, robots)
    [
      :city_destroyed,
      { city: city, robots: robots }
    ]
  end

  def update_move(robot, city)
    [:moved, { robot: robot, city: city }]
  end

  def destroy_city(city)
    directions = map.delete(city)
    directions.each_value do |next_city|
      map[next_city].filter! { |_d, c| c != city }
    end
  end

  def spawn_robots(n_robots)
    available_cities = map.keys.to_set
    @robots = (1..n_robots).map do |n|
      spawn_city = sampler.sample(available_cities.to_a)
      available_cities.delete(spawn_city)
      Robot.new(n.to_s, spawn_city)
    end
  end
end
