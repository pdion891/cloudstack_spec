module CloudstackSpec::Resource
  class SystemVm < Base
    # All about system VM...

    def initialize(name=nil, zonename=nil)
      @name   = name
      @connection = CloudstackSpec::Helper::Api.new.connection

      case @name
      when 'cpvm' && 'consoleproxy'
        @systemvmtype = 'consoleproxy'
      when 'ssvm' && 'secondarystoragevm'
        @systemvmtype = 'secondarystoragevm'
      else
        @systemvmtype = nil
      end
      @zone = get_zone(zonename)

      @sysvm = @connection.list_system_vms(:systemvmtype => @systemvmtype, zoneid: @zone['id'])
      @vmcount = @sysvm['count']
      @sysvm = @sysvm['systemvm'].first
      @runner = Specinfra::Runner
    end

    def exist?
      begin
        if @vmcount.nil?
          return false
        else
          return true
        end
      rescue Exception => e
        return false
      end
    end

    def running?
      puts $vm
      begin
        if @sysvm['state'] == 'Running'
          return true
        else
          return false
        end
      rescue
          return false
      end
    end

    def reachable?(port, proto, timeout)
      ip = @sysvm['publicip']
      @runner.check_host_is_reachable(ip, port, proto, timeout)
    end

  end
end
