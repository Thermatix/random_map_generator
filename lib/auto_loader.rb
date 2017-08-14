%w{../../lib ../../app}.each do |path|
  expanded_path = File.expand_path(path,__FILE__)
  $LOAD_PATH.unshift(expanded_path) unless $LOAD_PATH.include?(expanded_path)
end
class Object
  def self.inherited(base)
    puts base
    base.extend(Class_Methods)
    super
  end

  module Class_Methods
  
    def const_missing(name)
      puts "loading %s" % name
      path = name.to_s.split('::').compact.map(&:downcase).join('/') 
      require path
      self.const_get(name)
    end

  end

  extend Class_Methods
end
