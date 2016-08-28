module CloudstackSpec
  module Resource
    ##
    #
    # networks tiers inside VPC
    #
    # Arguments:
    #   name:     (string, default='rspec-vpc-tier')
    #   offering: (string, default='DefaultIsolatedNetworkOfferingForVpcNetworks')
    #   acl:      (string, default='default_allow')
    #   gateway:  (string)
    #   netmask:  (string)
    #
    class VpcTier
      include Base
      attr_reader :name

      def set_defaults
        @name     ||= 'rspec-vpc-tier'
        @offering ||= 'DefaultIsolatedNetworkOfferingForVpcNetworks'
        @acl      ||= 'default_allow'
      end

        def initialize(params = {})
        params.each { |key, value| instance_variable_set("@#{key}", value) }
        set_defaults
        @connection = CloudstackSpec::Helper::Api.new.connection
        @zone = $zone ? $zone : get_zone
        @runner = Specinfra::Runner
      end

      def exist?
        !this_tier.empty? ? true : false
      end

      def created?
        if !exist?
          @connection.create_network(
            name: @name,
            displaytext: @name,
            networkofferingid: offering_id(@offering),
            zoneid: @zone['id'],
            vpcid: $vpc['id'],
            gateway: @gateway,
            netmask: @netmask,
            aclid: acl_id(@acl)
          )
        else
          puts '  already exist'
          true
        end
      end

      def destroy?
        if exist?
          sleep(5)
          job = @connection.delete_network(id: this_tier['id'])
          job_status?(job['jobid'])
        else
          puts '  Does not exist'
          false
        end
      end

      private

      def this_tier
        # CloudStack API does not search by name for networks
        networks = @connection.list_networks(
          listall: true,
          vpcid: $vpc['id']
        )
        networks = networks['network']
        if networks.nil?
          {}
        else
          network = networks.select { |net| net['name'] == @name }
          network.first
        end
      end

      def offering_id(name)
        offering = @connection.list_network_offerings(name: name)
        offering = offering['networkoffering'].first
        offering['id']
      end

      def acl_id(name)
        acl = @connection.list_network_acl_lists(name: name)
        acl = acl['networkacllist'].first
        acl['id']
      end
    end
  end
end
