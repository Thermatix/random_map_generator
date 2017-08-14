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
      
      #TODO:should be able to define default values and add options, for example is_array: true or somthing
      def field(name,type=String)
        @fields[name] = type  
        define_instance_method(:"%s=" % name) do |value|
          instance_variable_set(:"@%" % name,value)
        end
        define_instance_method(:"%s" % name) do
          instance_variable_get(:"@%" % name) 
        end
      end

      def create(from_file)
        @bject = self.new
      end
      
    end
    
    def self.extended(base)
      base.extend(Singleton_Methods)
      base.instance_variable_set(:@fields,{})
    end

  end
end
