module CloudstackSpec::Resource
  class Zone < Base
    # All about zone...
    def initialize(name=nil)
      @connection = CloudstackSpec::Helper::Api.new.connection
      @zone = this_zone(name)
    end

    def this_zone(name)
      if name.nil?
        # if zone name not define, thake the first one
        zone = @connection.list_zones['zone'].first
        @name = zone['name']
      else 
        @name = name
        zone = @connection.list_zones(:name => name)['zone'].first
      end
      return zone
    end

    #####

    def exist?
      #zone = @connection.list_zone(:name => name)
      if @zone.nil?
        return false
      else
        return true
      end
    end

    def allocated?
      if @zone['allocationstate'] == 'Enabled'
        return true
      else
        return @zone['allocationstate']
      end
    end

    def local_storage
      return @zone['localstorageenabled']
    end

    def security_group
      return @zone['securitygroupsenabled']
    end

    def network_type
      # return "Basic" or "Advanced"
      return @zone['networktype']
    end
  end
end