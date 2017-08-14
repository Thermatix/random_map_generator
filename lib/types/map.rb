module Map_Generator
  module Types
    class Map
      include Format    
      fields size_x: Integer,size_y: Integer, max_height: Integer
      fields tile_map: Tiles

      def initialize(from_file=false)
        unless from_file
          @size_x = 100
          @size_y = 100
          @max_height = 256
          @tile_map =  Array.new(@size_x,Array.new(@size_y,[]))
        end
      end

    end
  end
end
