module CloudstackSpec
  module Resource
    ##
    #
    # VPC
    #
    # Arguments:
    #   name:     (string, default='rspec-vpc1')
    #   offering: (string, default='Default VPC offering')
    #   cidr:     (string)
    #
    class Vpc
      include Base

      def set_defaults
        @name ||= 'rspec-vpc1'
        @offering ||= 'Default VPC offering'
      end

      def initialize(params = {})
        params.each { |key, value| instance_variable_set("@#{key}", value) }
        set_defaults
        @connection = CloudstackSpec::Helper::Api.new.connection
        @zone = $zone ? $zone : get_zone
        @runner = Specinfra::Runner
        if this_vpc.empty?
          @router = nil
        else
          @router = @connection.list_routers(vpcid: this_vpc['id'])['router'].first
        end
        $vpc = this_vpc
      end

      def exist?
        this_vpc.empty? ? false : true
      end

      def ready?
        if @router['state'] == 'Running'
          if @router['version'] >= config_router_version
            true
          else
            "VR version #{@router['version']}"
          end
        else
          false
        end
      rescue
        false
      end

      def reachable?(port, proto, timeout)
        ip = @router['publicip']
        @runner.check_host_is_reachable(ip, port, proto, timeout)
      end

      def created?
        if self.exist?
          puts "  VPC already exist"
          true
        else
          job = @connection.create_vpc(
            name:          @name,
            displaytext:   @name,
            cidr:          @cidr,
            vpcofferingid: vpc_offering_id(@offering),
            zoneid:        @zone['id']
          )
          job_status = job_status?(job['jobid'])
          @router = @connection.list_routers(vpcid: this_vpc['id'])['router'].first
          $vpc = this_vpc
          job_status
        end
      end

      def destroy?
        sleep(5)
        if self.exist?
          job = @connection.delete_vpc(id: this_vpc['id'])
          job_status?(job['jobid'])
        else
          puts "  Does not exist"
          false
        end
      end

      def enable_remote_vpn
        vpn = @connection.list_remote_access_vpns(publicipid: publicip_snat_id)
        if vpn.empty?
          newvpn = @connection.create_remote_access_vpn(publicipid: publicip_snat_id)
          job_status?(newvpn['jobid'])
          vpn = @connection.list_remote_access_vpns(publicipid: publicip_snat_id)
        end
        vpn = vpn['remoteaccessvpn'].first
        true unless vpn.empty?
      end

      def remote_vpn_enabled?
        a = @connection.list_remote_access_vpns(listall: true, publicipid: publicip_snat_id)
        if a.empty?
          false
        else
          puts "    Pubic IP = #{a['remoteaccessvpn'].first['publicip']}"
          puts "    PreShared Key = #{a['remoteaccessvpn'].first['presharedkey']}"
          true
        end
      end


      private

      def this_vpc
        vpc = @connection.list_vpcs(listall: true, name: @name)
        vpc.empty? ? {} : vpc['vpc'].first
      end

      def first_vm_id
        vm = @connection.list_virtual_machines(vpcid: vpc['id'])
        false if vm.empty?
        vm['virtualmachine'].first['id']
      end

      def first_tier_id
        net = @connection.list_vpcs(id: vpc['id'])
        net['vpc'].first['network'].first['id']
      end

      def publicip_snat_id
        # get the id of the sourceNAT public IP for the current VPC
        public_ip = @connection.list_public_ip_addresses(vpcid: this_vpc['id'], issourcenat: true)
        public_ip = public_ip['publicipaddress'].first
        public_ip['id']
      end

      def vpc_offering_id(offering_name)
        offering = @connection.list_vpc_offerings(name: offering_name)['vpcoffering'].first
        offering['id']
      end

      def config_router_version
        @connection.list_configurations(name: 'minreq.sysvmtemplate.version')['configuration'].first['value']
      end
    end
  end
end
