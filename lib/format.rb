module Map_Generator

  module Format

    Base_Types = {
      Integer => 0,
      String  => 1 
    }

    module Singleton_Methods

      def fields(**args)
        args.each do |name,type|
          field(name,type)
        end
      end
      
      def field(name,type=String)
        @fields[name] = type  
        define_instance_method(:"%s=" % name) do |value|
          instance_variable_set(:"@%" % name,value)
        end
        define_instance_method(:"%s" % name) do
          instance_variable_get(:"@%" % name)
        end
      end
      
    end
    
    def self.extended(base)
      base.extend(base)
      base.instance_variable_set(:@fields,{})
    end

  end
end
