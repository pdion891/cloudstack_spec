module CloudstackSpec::Resource
  class VirtualMachine < Base
    # do nothing
    attr_reader :name

    def initialize(name=nil, zonename=nil)
      @name   = name
      @connection = CloudstackSpec::Helper::Api.new.connection
      @zone = get_zone(zonename)
      @runner = Specinfra::Runner

    end

    def vm
      @connection.list_virtual_machines(name: @name, zoneid: @zone['id'])
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


  end
end
