#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ruby2d'
require_relative 'game'
require_relative '2d/map'

map = Map.new
map.draw

set title: 'Robot Wars', width: map.width, height: map.height

show
