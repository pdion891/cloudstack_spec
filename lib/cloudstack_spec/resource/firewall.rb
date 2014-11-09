module CloudstackSpec::Resource
  class Firewall < Base
    # do nothing

    def initialize(name='rspec-vpc1')
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

  end
end