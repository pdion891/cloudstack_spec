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
        if network.count >= 1
          return true
        else
          return false
        end
      rescue Exception => e
        return false
      end
    end

    def ready?
      #
      # verify the VR is running for this network and run the proper version.
      vr = @connection.list_routers(:guestnetworkid => state = network.first['id'])['router'].first
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
      if network.count >= 1
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
        # CloudStack API does not search by name for networks
        networks = @connection.list_networks(zoneid: @zone['id'])['network']
        networks = networks.select { |net| net['name'] == @name }
      end

  end
end