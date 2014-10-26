module CloudstackSpec::Resource
  class Vpc < Base
    # do nothing

    def initialize(name='rspec-vpc1', zonename=nil)
      @name   = name
      @connection = CloudstackSpec::Helper::Api.new.connection
      @zone = get_zone(zonename)
      @runner = Specinfra::Runner
      vpc = @connection.list_vpcs(listall: true, name: @name)
      if vpc.empty?
        @vpc = nil
        @router = nil
      else
        @vpc = vpc['vpc'].first
        @router = @connection.list_routers(vpcid: @vpc['id'])['router'].first
      end
    end
    
    def exist?
        if @vpc.nil?
          return false
        else
          return true
        end
    end

    def ready?
      begin
        if @router['state'] == 'Running'
          if @router['version'] == CloudstackSpec::Helper::Api.new.version
            return true
          else
            return "VR version #{@router['version']}"
          end
        else
          return false
        end
      rescue
          return false
      end
    end

    def reachable?(port, proto, timeout)
      ip = @router['publicip']
      @runner.check_host_is_reachable(ip, port, proto, timeout)
    end

    def created?(cidr='10.10.0.0/22')
      if self.exist?
        puts "  VPC already exist"
        return false
      else
        job = @connection.create_vpc(
                :name => @name,
                :displaytext => @name,
                :cidr => cidr,
                :vpcofferingid => vpc_offering_id,
                :zoneid => @zone['id']
                )
        job_status = job_status?(job['jobid'])
        @vpc = @connection.list_vpcs(listall: true, name: @name)['vpc'].first
        @router = @connection.list_routers(vpcid: @vpc['id'])['router'].first
        return job_status
      end
    end

    def destroy?
      if self.exist?
        job = @connection.delete_vpc(id: @vpc['id'])
        return job_status?(job['jobid'])
      else
        puts "  Does not exist"
        return false
      end
    end

    def enable_remote_vpn
      #public_ip = publicip_snat_id
      newvpn =  @connection.create_remote_access_vpn(publicipid: publicip_snat_id)
      job_status?(newvpn['jobid'])
      vpn = @connection.list_remote_access_vpns(id: newvpn['id'])
      vpn = vpn['remoteaccessvpn'].first
      #puts vpn1
      if ! vpn.empty?
        return true
      end
    end

    def remote_vpn_enabled?
      a = @connection.list_remote_access_vpns(listall: true, publicipid: publicip_snat_id)
      puts "    Pubic IP = #{a['remoteaccessvpn'].first['publicip']}"
      puts "    PreShared Key = #{a['remoteaccessvpn'].first['presharedkey']}"
      if a.empty?
        false
      else
        true
      end
    end

    def open_pf_ssh
      port = 22
      proto = 'tcp'
      vmid = first_vm_id
      if ! vmid
        return false
      end
      new_rule = @connection.create_port_forwarding_rule(
                    ipaddressid: publicip_id, 
                    virtualmachineid: vmid,
                    privateport: port,
                    publicport: port,
                    networkid: first_tier_id, 
                    protocol: proto)
      #return new_rule['ipaddress']
      return true
    end

    private

      def first_vm_id
        vm = @connection.list_virtual_machines(vpcid: @vpc['id'])
        if vm.empty?
          return false
        end
        vm['virtualmachine'].first['id']
      end

      def first_tier_id
        net = @connection.list_vpcs(id: @vpc['id'])
        net = net['vpc'].first['network'].first['id']
        return net
      end

      def publicip_id
        public_ip = @connection.list_public_ip_addresses(vpcid: @vpc['id'], issourcenat: false)
        if public_ip['count'] < 1
          puts "    Associating Public IP to VPC"
          newip = @connection.associate_ip_address(vpcid: @vpc['id'])
          sleep 5
          public_ip = @connection.list_public_ip_addresses(vpcid: @vpc['id'], issourcenat: false)        
        end
        public_ip = public_ip['publicipaddress'].first
        return public_ip['id']        
      end

      def publicip_snat_id
        # get the id of the sourceNAT public IP for the current VPC
        public_ip = @connection.list_public_ip_addresses(vpcid: @vpc['id'], issourcenat: true)
        public_ip = public_ip['publicipaddress'].first
        return public_ip['id']
      end

      def vpc_offering_id(offering_name="Default VPC offering")
        offering = @connection.list_vpc_offerings(name: offering_name)['vpcoffering'].first
        return offering['id']
      end

  end
end
