module Map_Generator
  class Height_Map < Generator
    extend Helpers::Math
    class << self
      
      def main(map_array)
        ground_level = map_array.max_height / 4
        fuzzy = map_array.max_height / 6
        level = {
          x: map_array.size_x - 1,
          y: map_array.size_y - 1
        }
        fzy = rand_value(ground_level,fuzzy)
        seed_corner(map_array,ground_level,fuzzy)
        cords = {
          x1:0,
          y1:0,
          x2:map_array.size_x - 1,
          y2:map_array.size_y - 1
        }
        @step = 1
        step(map_array,level,fzy,cords)

      end

      def step(map_array,level,fzy,cords)
        return map_array unless level[:x] > 0 && level[:y] > 0
        diamond_step(map_array,level,fzy,cords)
        square_step(map_array,level,fzy,cords)
        step(map_array,{x: level[:x] / 2, y: level[:y] / 2}, fzy / 2,cords)
      end

      def seed_corner(map_array,height,fuzzy)
        map_array[0][0] = rand_value(height,fuzzy)
        map_array[map_array.size_x - 1][0] = rand_value(height,fuzzy)
        map_array[0][map_array.size_y - 1] = rand_value(height,fuzzy)
        map_array[map_array.size_x - 1][map_array.size_y - 1] = rand_value(height,fuzzy)
      end

      def diamond_step(map_array,level,fzy,cords)
        x = cords[:x1] + level[:x]
        y = cords[:y1] + level[:y]
        while x < cords[:x2] && y < cords[:y2] do
          avg = Mean(get_corner_values(map_array,x,y,level))
          map_array[x - level[:x] / 2][y - level[:y] / 2] = avg + rand_value(avg)
          x += level[:x]
          y += level[:y]
        end
      end

      def square_step(map_array,level,fzy,cords)
        x = cords[:x1] + 2 * level[:x]
        y = cords[:y1] + 2 * level[:y]
        while x < cords[:x2] &&  y < cords[:y2] do
          a,b,c,_ = get_corner_values(map_array,x,y,level)
          e = map_array[x - level[:x] / 2][y - level[:y] / 2]
          map_array[x - level[:x]][y - level[:y] / 2] = 
						Mean(a, c + e + map_array[x - 3 * level[:x] / 2][y - level[:y] / 2]) + rand_value(e,fzy)
          map_array[x - level[:x] / 2][y - level[:y]] = 
            Mean(a + b + e + map_array[x - level[:x] / 2][y - 3 * level[:y] / 2]) +  rand_value(e,fzy)
          x +=  level[:x]
          y +=  level[:y]
        end
      end

      def rand_value(base=0,fuzzy=(base / 4),celling=nil)
        rand((base - fuzzy)..(celling || base + fuzzy))
      end

      def get_corner_values(map_array,x,y,level)
        (((([] << map_array[x - level[:x]][y - level[:y]]) <<
          map_array[x][y - level[:y]]) <<
          map_array[x - level[:x]][y]) <<
          map_array[x][x])
      end

    end
  end
end
