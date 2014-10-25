module CloudstackSpec::Resource
  class VirtualMachine < Base
    # do nothing
    attr_reader :name

    def initialize(name='rspec-test1', zonename=nil)
      @name   = name
      @connection = CloudstackSpec::Helper::Api.new.connection
      @zone = get_zone(zonename)
      @runner = Specinfra::Runner
    end

    def exist?
      begin  
        if vm['count'].nil?
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
        if vm['virtualmachine'].first['state'] == 'Running'
          return true
        else
          return false
        end
      rescue
          return false
      end
    end

    def reachable?(port, proto, timeout)
      ip = vm['virtualmachine'].first['nic'].first['ipaddress']
      @runner.check_host_is_reachable(ip, port, proto, timeout)
    end

    def ready?
      if ! vm["count"].nil?
        state = vm["virtualmachine"].first["state"]
        if state
          return true
        else
          return tpl["template"].first["status"]
        end
      else
        return "#{name}: not found"
        #return false
      end
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
      rescue Exception => e
        creation_job = "vm creation fail with #{e.message}"
      end
      if UUID.validate(creation_job) == true
        puts "  jobid: #{creation_job}"
        return job_status?(creation_job)
      else
        puts "  #{creation_job}"
        return false
      end
    end

    def destroy?
      if self.exist?
        job = @connection.destroy_virtual_machine(id: vm['virtualmachine'].first['id'], expunge: true)
        job_status?(job['jobid'])
      else
        puts "  Does not exist"
        return false
      end
    end


    private 

      def job_status?(jobid)
          job = @connection.query_async_job_result(jobid: jobid)
#          jobstatus = job['jobstatus']        
#        until jobstatus != 0
        until job['jobstatus'] != 0
          puts "  async job in progress..."
          job = @connection.query_async_job_result(jobid: jobid)
#          jobstatus = job['jobstatus']
          sleep(5)
        end
        if job['jobresultcode'] == 0
          return true
        else
          return false
        end
      end

      def vm
        @connection.list_virtual_machines(name: @name, zoneid: @zone['id'])
      end

      def get_template_id(template_name=nil)
        if template_name.nil?
          tpl = @connection.list_templates(:templatefilter => "featured", :zoneid => @zone['id'])
        else
          tpl = @connection.list_templates(:name => template_name, :templatefilter => "featured", :zoneid => @zone['id'])
        end
        if ! tpl.empty?
          tpl = tpl['template'].first['id']
          return tpl
        else
          return ''
        end
      end

      def get_network_id(network_name)
        # CloudStack API does not search by name for networks
        networks = @connection.list_networks(zoneid: @zone['id'])['network']
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

      def create_virtual_machine(name='rspec-test1',network_name='rspec-test1',template_name=nil,offering_name=nil)
        networkid = get_network_id(network_name)

        #templateid = @connection.list_templates(:templatefilter => "all", :name => template_name)['template'].first['id']
        jobid = @connection.deploy_virtual_machine(
                        zoneid: @zone['id'],
                        serviceofferingid: get_systemoffering_id,
                        templateid: get_template_id,
                        name: name,
                        displayname: name,
                        networkids: networkid
                      )

      end

  end
end
