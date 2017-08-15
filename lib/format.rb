module Map_Generator

  module Format

    Base_Types = {
      Integer => 0,
      String  => 1 
    }

    module Singleton_Methods

      def fields(**args)
        args.each do |name,type|
          set_field(type: type, name: name)
        end
      end

      def field(name,**kwargs)
        set_field(**kwargs.merge({name: name}))
      end
      

      def create(from_file=nil)
        @fields.each_with_object(self.new) do |(name,opts),object|
          object.instance_variable_set("@%s" % name, callable(opts[:default],object))
        end
      end
      

      def callable(def_value,object)
        def_value.respond_to?(:call) ? object.instance_eval(&def_value) : def_value
      end

      def set_field(name:,type:String,default:nil,container:nil,accessors: true)
        @fields[name] = {type: type, default: default, container: container} 
        if accessors
          define_method("%s=" % name) do |value|
            instance_variable_set("@%s" % name,value)
          end
          define_method("%s" % name) do
            instance_variable_get("@%s" % name) 
          end
        end
        instance_variable_set("@%s" % name,default)
      end
    end
    
    def self.included(base)
      base.extend(Singleton_Methods)
      base.instance_variable_set(:@fields,{})
    end

  end
end
