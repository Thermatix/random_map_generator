module Map_Generator
  module Helpers
    module Math
      def Sum(values)
        values.inject(0.0) { |result, el| result + el }
      end

      def Mean(*values)
        (Sum(values.flatten) / values.size).floor
      end

    end
  end

end
