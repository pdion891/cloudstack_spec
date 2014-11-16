module CloudstackSpec::Resource
  class VpcTier < Base
    attr_reader :name

    def initialize(name='tier1', zonename=nil)
      @name   = name
      @connection = CloudstackSpec::Helper::Api.new.connection
      @zone = get_zone(zonename)
      @runner = Specinfra::Runner
    end

    def exist?
      begin  
        if get_tier.count >= 1
          return true
        else
          return false
        end
      rescue Exception => e
        return false
      end
    end

    def created?
      unless self.exist?
        @connection.create_network(
                    :name => @name, 
                    :displaytext => @name, 
                    :networkofferingid => get_offering_id, 
                    :zoneid => @zone['id'],
                    :vpcid => $vpc['id'],
                    :gateway => '10.10.0.1',
                    :netmask => '255.255.255.0',
                    :aclid => get_acl_id
                   )
      else
        print "already exist"
        #return false
      end
    end

    def destroy?
      if self.exist?
        job = @connection.delete_network(id: get_tier['id'])
        job_status?(job['jobid'])
      else
        puts "  Does not exist"
        return false
      end
    end


    private

      def get_tier
        # CloudStack API does not search by name for networks
        networks = @connection.list_networks(:listall => true, vpcid: $vpc['id'])
        networks = networks['network']
        if networks.nil?
          return {}
        else
          networks = networks.select { |net| net['name'] == @name }
        end
      end

      def get_offering_id
        offering = @connection.list_network_offerings(:name => "DefaultIsolatedNetworkOfferingForVpcNetworks")
        offering = offering["networkoffering"].first
        return offering['id']
      end

      def get_acl_id(name='default_allow')
        acl = @connection.list_network_a_c_l_lists(name: name)
        acl = acl['networkacllist'].first
        return acl['id']
      end
  end
end