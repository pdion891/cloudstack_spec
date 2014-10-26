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


    private 

      def vpc_offering_id(offering_name="Default VPC offering")
        offering = @connection.list_vpc_offerings(name: offering_name)['vpcoffering'].first
        return offering['id']
      end

  end
end
