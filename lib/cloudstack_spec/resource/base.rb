module CloudstackSpec::Resource
  class Base
    attr_reader :name

    def initialize(name=nil)
      @name   = name
      @connection = CloudstackSpec::Helper::Api.new.connection
    end

    def to_s
      type = self.class.name.split(':')[-1]
      type.gsub!(/([a-z\d])([A-Z])/, '\1 \2')
      #type.capitalize!
      %Q!#{type}:"#{@name}"!
    end
  
    def inspect
      to_s
    end
  
    def to_ary
      to_s.split(" ")
    end
  end
end