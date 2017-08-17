module Map_Generator
  module Helpers
    module Math

      def self.included(base)
        base.extend(self)
      end

      def Sum(values)
        values.inject(0.0) { |result, el| result + el }
      end

      def Mean(*values)
        v = values.flatten
        res = (Sum(v) / v.size).floor
        (res == [] ? 0 : res).abs
      end


      def Max(max)
        val = yield
        val > max ? max : val
      end

      def Min(min=0)
        val = yield
        val < min ? min : val
      end

    end
  end

end
