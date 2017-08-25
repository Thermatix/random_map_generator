require 'colorize'
module Map_Generator
  module Types
    class Map
      include Format    
      include Enumerable
      fields size_x: Integer,size_y: Integer, max_height: Integer
      fields tile_atlas: Tile

      field :size_x, type: Integer, default: 40
      field :size_y, type: Integer, default: 40
      field :mx,  type: Integer, default: -> {@size_x - 1}
      field :my,  type: Integer, default: -> {@size_y - 1}
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

    def each(&block)
      @height_map.each(&block)
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
      row.map do |c,col=(c||0)|
        case true
        when col > (@max_height * 0.99).abs
          '~'.colorize(:light_white).on_light_white
        when col > (@max_height * 0.80).abs
          '\\'.colorize(:light_white).on_white
        when col > (@max_height * 0.50).abs
         (rand(0..9) > 2 ? ' ' : ',').colorize(:white).on_light_green
        when col > (@max_height * 0.30).abs
          (rand(0..19) > 1 ? ' '  : ',').colorize(:light_green).on_green
        when col > (@max_height * 0.20).abs
          (rand(0..9) > 5 ? '~' : '⌇').colorize(:light_yellow).on_yellow
        else
          (rand(0..9) > 5 ? '~' : '⌇').colorize(:white).on_light_blue
        end
      end
    end
     
    end
  end
end
