module Map_Generator
  module Helpers
    module Math
      def Sum(values)
        values.inject(0.0) { |result, el| result + el }
      end

      def Mean(*values)
        v = values.flatten
        res = (Sum(v) / v.size).floor
        (res == [] ? 0 : res).abs
      end

    end
  end

end
