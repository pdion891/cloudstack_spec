module CloudstackSpec::Resource
  class Zone < Base
    # All about zone...
    #####
    def exist?
      #zone = @connection.list_zone(:name => name)
      if @zonename.nil?
        return false
      else
        return true
      end
    end

    def allocated?
      if @zonename['allocationstate'] == 'Enabled'
        return true
      else
        return @zonename['allocationstate']
      end
    end

    def local_storage
      return @zonename['localstorageenabled']
    end

    def security_group
      return @zonename['securitygroupsenabled']
    end

    def network_type
      # return "Basic" or "Advanced"
      return @zonename['networktype']
    end

    private

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

    # end private
  end
end