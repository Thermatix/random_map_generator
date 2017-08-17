module Map_Generator
  class Height_Map < Generator
    class << self
    include Helpers::Math

			Shapes = {
				diamond: {
					top:		->	(map_array,x,y,level) {map_array[x][Min(){y - level[:y]}]},
					left:		->	(map_array,x,y,level) {map_array[Min(){x - level[:x]}][y]},
					right:	->	(map_array,x,y,level) {map_array[Max(map_array.size_x - 1){x + level[:x]}][y]},
					bottom: ->	(map_array,x,y,level) {map_array[x][Max(map_array.size_y - 1){y + level[:y]}]}
				},
				square: {
					tp_left:		-> (map_array,x,y,level) {map_array[Min(){x - level[:x]}][Min(){y - level[:y]}]},
					tp_right:		-> (map_array,x,y,level) {map_array[Max(map_array.size_x - 1){x + level[:x]}][Min(){y - level[:y]}]},
					btm_left:		-> (map_array,x,y,level) {map_array[Min(){x - level[:x]}][Max(map_array.size_y - 1){y + level[:y]}]},
					btm_right:	-> (map_array,x,y,level) {map_array[Max(map_array.size_x - 1){x + level[:x]}][Max(map_array.size_y - 1){y + level[:y]}]}
				}
			}

      def main(map_array)
        ground_level = map_array.max_height / 4
        fuzzy = map_array.max_height / 8
        level = {
          x: (map_array.size_x - 1) / 2,
          y: (map_array.size_y - 1) / 2
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
				map_array.display
        diamond_step(map_array,level,fzy,cords)
				map_array.display
        square_step(map_array,level,fzy,cords)
				map_array.display
        step(map_array,{x: level[:x] / 2, y: level[:y] / 2}, fzy / 2,cords)
      end

      def seed_corner(map_array,height,fuzzy)
        map_array[0][0] = rand_value(height,fuzzy,height)
        map_array[map_array.size_x - 1][0] = rand_value(height,fuzzy,height)
        map_array[0][map_array.size_y - 1] = rand_value(height,fuzzy,height)
        map_array[map_array.size_x - 1][map_array.size_y - 1] = rand_value(height,fuzzy,height)
      end

			def diamond_step(map_array,level,fzy,cords)
				x = level[:x]
				while x < cords[:x2] do
					y = (x + level[:y]) % map_array.size_y
					while y < cords[:y2] do
						avg = Mean(get_shape_values(:diamond,map_array,x,y,level))
						map_array[x][y] = avg + rand_value(avg,fzy,map_array.max_height)
						y += level[:y]
					end
					x += level[:x]
				end
			end
		
			def square_step(map_array,level,fzy,cords)
				x = level[:x]
				while x < cords[:x2] do
					y = level[:y]
					while y < cords[:y2] do
						avg = Mean(get_shape_values(:diamond,map_array,x,y,level))
						map_array[x][y] = avg + rand_value(avg,fzy,map_array.max_height)
						y += level[:y]
					end
					x += level[:x]
				end
			end
      # def diamond_step(map_array,level,fzy,cords)
      #   x = cords[:x1] + level[:x]
      #   y = cords[:y1] + level[:y]
      #   while x < cords[:x2] && y < cords[:y2] do
			# 		avg = Mean(get_shape_values(:diamond,map_array,x,y,level))
      #     map_array[x - level[:x] / 2][y - level[:y] / 2] = avg + rand_value(avg)
      #     x += level[:x]
      #     y += level[:y]
      #   end
      # end
      #
      # def square_step(map_array,level,fzy,cords)
      #   x = cords[:x1] + 2 * level[:x]
      #   y = cords[:y1] + 2 * level[:y]
      #   while x < cords[:x2] &&  y < cords[:y2] do
			# 		a,b,c,_ = get_shape_values(:square,map_array,x,y,level)
      #     e = map_array[x - level[:x] / 2][y - level[:y] / 2]
      #     map_array[x - level[:x]][y - level[:y] / 2] = 
			# 			Mean(a, c + e + map_array[x - 3 * level[:x] / 2][y - level[:y] / 2]) + rand_value(e,fzy)
      #     map_array[x - level[:x] / 2][y - level[:y]] = 
      #       Mean(a + b + e + map_array[x - level[:x] / 2][y - 3 * level[:y] / 2]) +  rand_value(e,fzy)
      #     x +=  level[:x]
      #     y +=  level[:y]
      #   end
      # end

      def rand_value(base=0,fuzzy=(base / 4),celling=nil)
				if celling && base > celling
					celling
				else
					rand((base - fuzzy)..(celling || base + fuzzy))
				end
      end
			
			def	get_shape_values(shape,*args)
				Shapes[shape].inject([]) do |vals,(_,prc)|
					vals.push prc.call(*args)
				end
			end



    end
  end
end
