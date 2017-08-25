module Map_Generator
  module Helpers
    module Math

      def self.included(base)
        base.extend(self)
      end

      def Sum(*values)
        values.flatten.inject(0.0) { |result, el| (result||0) + (el||0) }
      end

      def Mean(*values)
        v = values.flatten
        res = (Sum(v) / v.size).floor
        (res == [] ? 0 : res).abs
      end

      def Median(*values)
        sorted = values.flatten.sort
        len = sorted.length
        (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
      end

      def Max(max,val=nil,&block)
        val = val || block.call
        val > max ? max : val
      end

      def Min(min=0,val=nil,&block)
        val = val || block.call
        val < min ? min : val
      end

      def MaxMin(max,min=0)
        val = yield
        return val if val == Max(max,val) && val == Min(min,val)
        val < Median(((min)..(max)).to_a) ? min : max
      end


    end
  end

end
