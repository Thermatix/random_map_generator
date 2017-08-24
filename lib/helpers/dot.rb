module Map_Generator
  module Helpers
    module Dot
      def Dot(*args)
        if args.first.is_a? Hash
          args.first.tap {|h| h.extend(add_accesors(*h.keys))}
        else
          add_accesors(*args)
        end
      end

      def add_accesors(*accessors)
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
