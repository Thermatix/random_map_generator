%w{../../lib ../../app}.each do |path|
  expanded_path = File.expand_path(path,__FILE__)
  $LOAD_PATH.unshift(expanded_path) unless $LOAD_PATH.include?(expanded_path)
end
class Object
  def self.inherited(base)
    base.extend(Class_Methods)
    super
  end

  def const_missing(const)
    puts "loading(in Object) %s" % const.to_s
    path = const.to_s.split('::').compact.map(&:downcase).join('/') 
    require path
    self.const_get(const)
  end
  class << self
    def const_missing(const)
      puts "loading(in Object class << self) %s" % const.to_s
      path = const.to_s.split('::').compact.map(&:downcase).join('/') 
      require path
      self.const_get(const)
    end
  end
  module Class_Methods
    class << self
      def const_missing(const)
        puts "loading(in Class_Methods class << self) %s" % const.to_s
        path = const.to_s.split('::').compact.map(&:downcase).join('/') 
        require path
        self.const_get(const)
      end
    end



    def const_missing(const)
      puts "loading(in Class_Methods) %s" % const.to_s
      path = const.to_s.split('::').compact.map(&:downcase).join('/') 
      require path
      self.const_get(const)
    end

  end

  extend Class_Methods
end

