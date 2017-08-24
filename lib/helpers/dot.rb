module Map_Generator
  module Helpers
    module Dot
      def Dot(*accessors)
        Module.new do 
          accessors.each do |acc|
            define_method(acc) do
              self[acc]
            end

            define_method("%s=" % acc) do |val|
              self[acc] = val
            end
          end
        end
      end
    end
  end
end
