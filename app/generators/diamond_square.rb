module Map_Generator
  class Height_Map < Generator
    class << self
    include Helpers::Dot
    include Helpers::Math

			Shapes = {
				diamond: {
					top:		->	(map_array,x,y,level) {
            map_array[Max(map_array.mx){x}][Min(){y - level.y}]
					},
					left:		->	(map_array,x,y,level) {
            map_array[Min(){x - level.x}][Max(map_array.my){y}]
					},
					bottom: ->	(map_array,x,y,level) {
            map_array[Max(map_array.mx){x}][Max(map_array.my ){y + level.y}]
					},
					right:	->	(map_array,x,y,level) {
            map_array[Max(map_array.mx){x + level.x}][Max(map_array.my) {y}]
					}
				},
				square: {
					tp_left:		-> (map_array,x,y,level) {
            map_array[Min(){x - level.x}][Min(){y - level.y}]
					},
					tp_right:		-> (map_array,x,y,level) {
            map_array[Max(map_array.mx){x + level.x}][Min(){y - level.y}]
					},
					btm_left:		-> (map_array,x,y,level) {
            map_array[Min(){x - level.x}][Max(map_array.my){y + level.y}]
					},
					btm_right:	-> (map_array,x,y,level) {
            map_array[Max(map_array.mx){x + level.x}][Max(map_array.my){y + level.y}]
					}
				}
			}

      def main(map_array)
        ground_level = map_array.max_height / 8
        fuzzy = map_array.max_height / 16 
        level = {
          x: (map_array.size_x ) / 2,
          y: (map_array.size_y ) / 2
        }
        level.extend(Dot(*level.keys))
        fzy = rand_value(ground_level,fuzzy)
				puts fzy
        seed_corner(map_array,ground_level,fuzzy)
        cords = {
          x1:0,
          y1:0,
          x2:map_array.size_x,
          y2:map_array.size_y
        }
        cords.extend(Dot(*cords.keys))
        @step = 1
        step(map_array,level,fzy,cords)

      end

      def step(map_array,level,fzy,cords)
        return map_array unless level.x > 0 && level.y > 0
        diamond_step(map_array,level,fzy,cords)
        square_step(map_array,level,fzy,cords)
        level.x /= 2
        level.y /= 2
        step(map_array,level, fzy / 2,cords)
      end

      def seed_corner(map_array,height,fuzzy)
        map_array[0][0] = rand_value(height,fuzzy,height)
        map_array[map_array.mx][0] = rand_value(height,fuzzy,height)
        map_array[0][map_array.my] = rand_value(height,fuzzy,height)
        map_array[map_array.mx][map_array.my] = rand_value(height,fuzzy,height)
      end


      def diamond_step(map_array,level,fzy,cords)
        iteration(cords,level) do |x,y|
          avg = Mean(get_shape_values(:square,map_array,x,y,level))
          map_array[x][y] = avg + rand_value(avg)
        end
      end

      def square_step(map_array,level,fzy,cords)
        iteration(cords,level) do |x,y,x_off=(x + (level[:x] * 2)),y_off=(y + (level[:y] * 2))|
          avg = Mean(get_shape_values(:diamond,map_array,x,y,level))
          map_array[Max(map_array.mx){x_off}][Max(map_array.my){y_off}] = avg + rand_value(avg)
        end
      end

      def iteration(cords,level)
        unless level.x < 1 || level.y < 1
          (cords.x2 / level.x).times do |xs,x=(xs * level[:x])|
            (cords.y2 / level.y).times do |ys,y=(ys * level[:y])|
              yield(x,y)
            end
          end
        end
      end

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
