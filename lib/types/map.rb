require 'colorize'
module Map_Generator
  module Types
    class Map
      include Format    
      fields size_x: Integer,size_y: Integer, max_height: Integer
      fields tile_atlas: Tile

      field :size_x, type: Integer, default: 15
      field :size_y, type: Integer, default: 30
      field :max_height, type: Integer, default: 256
      field :height_map, type: Integer, container: Array, accessors: false, default: -> {
        Array.new(@size_x) {Array.new(@size_y,0)}
      }

    def [](index)
      @height_map[index]
    end

    def []=(index,val)
      @height_map[index] = val
    end

    def display
      colorise_map.each do |row|
        puts row.join('')
      end
    end

    def display_row(x)
      puts colorise_row(@height_map[x]).join('')
    end
  
    def colorise_map
      @height_map.map do |row|
        colorise_row(row)
      end
    end

    def colorise_row(row)
      row.map do |col|
        case true
          when col > 64
            ' '.colorize(:white).on_light_green
          when col > 32
            ','.colorize(:light_green).on_green
          when col > 16
            '\\'.colorize(:light_yellow).on_yellow
          else
            '~'.colorize(:white).on_light_blue
        end
      end
    end
     
    end
  end
end
