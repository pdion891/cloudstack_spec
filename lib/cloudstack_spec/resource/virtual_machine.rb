module CloudstackSpec::Resource
  class VirtualMachine < Base
    # do nothing
    attr_reader :name, :template_name, :zonename

    def initialize(name='rspec-test1', zonename=nil)
      @name   = name
      @template_name = ''
      @connection = CloudstackSpec::Helper::Api.new.connection
      @zone = get_zone(zonename)
      @runner = Specinfra::Runner
    end

    def exist?
      begin  
        if vm.empty?
          return false
        else
          return true
        end
      rescue Exception => e
        return false
      end
    end

    def running?
      begin
        if vm['state'] == 'Running'
          return true
        else
          return false
        end
      rescue
          return false
      end
    end

    def reachable?(port, proto, timeout)
      pf_rule = get_pf_rule
      if pf_rule.empty?
        ip = vm['nic'].first['ipaddress']
      else
        ip = pf_rule['ipaddress']
        port = pf_rule['publicport']
        proto = pf_rule['protocol']
      end
      @runner.check_host_is_reachable(ip, port, proto, timeout)
    end

    def created?
      # start the VM creation job
      # Return {true/false}
      if self.exist?
        creation_job = "Already exist" 
        puts "  #{creation_job}"
        return false
      end
      begin
        newvm = create_virtual_machine(@name)
        creation_job = newvm['jobid']
      rescue Exception => exception
        creation_job = "vm creation fail with #{exception.message}"
      end
      if UUID.validate(creation_job) == true
        return job_status?(creation_job)
      else
        puts "  #{creation_job}"
        return false
      end
    end

    def destroy?
      if self.exist?
        job = @connection.destroy_virtual_machine(id: vm['id'], expunge: true)
        job_status?(job['jobid'])
      else
        puts "  Does not exist"
        return false
      end
    end

    def open_pf_ssh
      # open port forwarding for ssh (tcp:22)
      port = 22
      proto = 'tcp'
      sleep(5)  # give move time to the vm to complete booting.
      if get_pf_rule.empty?
        new_rule = @connection.create_port_forwarding_rule(
                    ipaddressid: publicip_id, 
                    virtualmachineid: vm['id'],
                    privateport: port,
                    publicport: port,
                    networkid: vm['nic'].first['networkid'], 
                    protocol: proto )
      else
        #puts "      Port Forwarging rule already exist"
      end
      return true

    end


    private 

      def vm
        vm = @connection.list_virtual_machines(name: @name, zoneid: @zone['id'])
        if vm.empty?
          $vm = {}
          return {}
        else
          $vm = vm['virtualmachine'].first
          return vm['virtualmachine'].first
        end
      end

      def get_template_id
        if self.template_name.empty?
          tpl = @connection.list_templates(:templatefilter => "featured", :zoneid => @zone['id'])
        else
          tpl = @connection.list_templates(:name => self.template_name, :templatefilter => "all", :zoneid => @zone['id'])
        end
        if ! tpl.empty?
          tpl = tpl['template'].first['id']
          return tpl
        else
          return 'no featured template found'
        end
      end

      def get_network_id(network_name)
        # CloudStack API does not search by name for networks
        networks = @connection.list_networks(zoneid: @zone['id'])['network']
        return "NO NETWORK FOUND" if networks.nil?
        networks = networks.select { |net| net['name'] == network_name }
        return networks.first['id']
      end

      def get_systemoffering_id(offering_name=nil)
        if offering_name.nil?
          systemofferingid = @connection.list_service_offerings()['serviceoffering'].first['id']
        else
          systemofferingid = @connection.list_service_offerings(:name => offering_name)['serviceoffering'].first['id']
        end
        if UUID.validate(systemofferingid)
          return systemofferingid
        else
          return "invalid systemoffering"
        end
      end

      def create_virtual_machine(name='rspec-test1',network_name='tier11',offering_name=nil)
        networkid = get_network_id(network_name)
        jobid = @connection.deploy_virtual_machine(
                        zoneid: @zone['id'],
                        serviceofferingid: get_systemoffering_id,
                        templateid: get_template_id,
                        name: name,
                        displayname: name,
                        networkids: networkid
                      )
      end

      def publicip_id
        # public ip not used for SourceNAT
        public_ip = @connection.list_public_ip_addresses(vpcid: $vpc['id'], issourcenat: false)
        if public_ip.empty?
          puts "    Associating Public IP to VPC"
          newip = @connection.associate_ip_address(vpcid: $vpc['id'])
          sleep 5
          public_ip = @connection.list_public_ip_addresses(vpcid: $vpc['id'], issourcenat: false)        
        end
        public_ip = public_ip['publicipaddress'].first
        return public_ip['id']        
      end

      def get_pf_rule
        # retrieve Port Forwarding Rule for the VM if it exist
        pf_rules = @connection.list_port_forwarding_rules
        pf_rules = pf_rules['portforwardingrule']
        if pf_rules.nil?
          return {}
        else
          pf_rule = pf_rules.select { |rule| rule['virtualmachineid'] == vm['id'] }
          pf_rule.first
        end
      end

  end
end
