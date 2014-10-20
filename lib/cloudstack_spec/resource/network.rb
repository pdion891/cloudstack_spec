module CloudstackSpec::Resource
  class Network < Base
    # do nothing
    def initialize(name=nil, zonename=nil)
      @name   = name
      @connection = CloudstackSpec::Helper::Api.new.connection
      @version = CloudstackSpec::Helper::Api.new.version
      @zone = get_zone(zonename)
#      @network = @connection.list_networks(:name => @name, zoneid: @zone['id'])
    end

    def exist?
      begin  
        if network['count'].nil?
          return false
        else
          return true
        end
      rescue Exception => e
        return false
      end
    end

    def ready?
      #
      # verify the VR is running for this network and run the proper version.
      vr = @connection.list_routers(:guestnetworkid => state = network["network"].first['id'])['router'].first
      if ! vr.nil?
        if vr['state'] == 'Running'
          if vr['version'] == @version
            return true
          else
            return "VR version #{vr['version']}"
          end
        else
          return "VR state: #{vr['state']}"
        end
      else
        return "vr not found for network #{name}"
      end
    end

    def create
      if network['count'].nil?
        offering_id = @connection.list_network_offerings(:name => "DefaultIsolatedNetworkOfferingWithSourceNatService")["networkoffering"].first['id']
        newnetwork = @connection.create_network(
                    :name => @name, 
                    :displaytext => @name, 
                    :networkofferingid => offering_id, 
                    :zoneid => @zone['id']
                   )
      else
        return "network already exist"
      end
    end

    private

      def network 
        @connection.list_networks(:name => @name, zoneid: @zone['id'])
      end

  end
end