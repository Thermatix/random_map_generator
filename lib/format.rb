module Map_Generator

  module Format

    Base_Types = {
      Integer => 0,
      String  => 1 
    }

    module Singleton_Methods

      def fields(**args)
        args.each do |name,type|
          field(name,{type: type})
        end
      end
      
      def field(name,type:String,default:nil,container:nil)
        @fields[name] = type  
        define_instance_method(:"%s=" % name) do |value|
          instance_variable_set(:"@%" % name,value)
        end
        define_instance_method(:"%s" % name) do
          instance_variable_get(:"@%" % name) 
        end
      end

      def create(from_file)
        @fields.each_with_object(self.new) do |(name,opts),object|
          object.instance_variable_set(:"@%s" % name, callable(opts[:default],object))
        end
      end
      

      def callable(def_value,object)
        def_value.respond_to?(:call) ? object.instance_eval(&def_value) : def_value
      end
    end
    
    def self.extended(base)
      base.extend(Singleton_Methods)
      base.instance_variable_set(:@fields,{})
    end

  end
end
