module Map_Generator
  class Height_Map < Generator
    extend Helpers::Math
    class << self
      
      def main(map_array)
        ground_level = map_array.max_height / 4
        fuzzy = map_array.max_height / 8
        step_size = map_array.size_x - 1
        fzy = rand_value(ground_level,fuzzy)
        seed_corner(map_array,ground_level,fuzzy)
        cords = {
          x1:0,
          y1:0,
          x2:map_array.size_x,
          y2:map_array.size_y
        }
        step(map_array,step_size,fzy,cords)

      end

      def step(map_array,step_size,fzy,cords)
        return map_array unless step_size > 1
        diamond_step(map_array,step_size,fzy,cords)
        square_step(map_array,step_size,fzy,cords)
        step(map_array,step_size / 2, fzy / 2,cords)
      end

      def seed_corner(map_array,height,fuzzy)
        map_array[0][0] = rand_value(height,fuzzy)
        map_array[map_array.size_x][0] = rand_value(height,fuzzy)
        map_array[0][map_array.size_y] = rand_value(height,fuzzy)
        map_array[map_array.size_x][map_array.size_y] = rand_value(height,fuzzy)
      end

      def diamond_step(map_array,step_size,fzy,cords)
        x = cords[:x1] + step_size
        y = cords[:y1] + step_size
        while x < cords[:x2] do
          while y < cords[:y2] do
            avg = Mean(get_corner_values(map_array,x,y,step_size))
            map_array[x - step_size / 2][y - step_size / 2] = avg + fzy
            x += step_size
            y += step_size
          end
        end
      end

      def square_step(map_array)
        x = cords[:x1] + 2 * step_size
        y = cords[:y1] + 2 * step_size
        while x < cords[:x2] do
          while y < cords[:y2] do
            a,b,c,_ = get_corner_values(map_array,x,y,step_size)
            e = map_array[x - step_size / 2][y - step_size / 2]
            map_array[x - step_size][y - step_size / 2] = 
              Mean(a, c + e + map_array[x - 3 * step_size / 2][y - step_size / 2]) + fzy
            map_array[x - step_size / 2][y - step_size] = 
              Mean(a + b + e + map_array[x - step_size / 2][y - 3 * step_size / 2]) + fzy

          end
        end
      end

      def rand_value(base=0,fuzzy=3)
        rand((base - fuzzy)..(base + fuzzy))
      end

      def get_corner_values(map_array,x,y,step_size)
        (((([] << map_array[x - step_size][y - step_size]) <<
          map_array[x][y - step_size]) <<
          map_array[x - step_size][y]) <<
          map_array[x][x])
      end

    end
  end
end
