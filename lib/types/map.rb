module Map_Generator
  module Types
    class Map
      include Format    
      fields size_x: Integer,size_y: Integer, max_height: Integer
      fields tile_map: Tiles

      field :size_x, type: Integer, default: 100
      field :size_y, type: Integer, default: 100
      field :max_height, type: Integer, default: 256
      field :Height_Map, Type: Integer, container: Array, default: -> {
        Array.new(@size_x,Array.new(@size_y,[]))
      }


     
    end
  end
end
