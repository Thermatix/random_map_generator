module Map_Generator
  module Types
    class Map
      include Format    
      fields size_x: Integer,size_y: Integer, max_height: Integer
      fields tile_map: [Tiles]
    end
  end
end
