require './lib/auto_loader'
require 'helpers/math'
require 'format'
require 'generator'
require 'types/tiles'
require 'types/biome'
require 'types/map'
require 'generators/diamond_square'

Map_Generator::Height_Map.main(Map_Generator::Types::Map.create).display
