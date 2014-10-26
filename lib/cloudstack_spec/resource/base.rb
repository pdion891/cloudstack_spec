module CloudstackSpec::Resource
  class Base
    attr_reader :name

    def initialize(name=nil)
      @name   = name
      @connection = CloudstackSpec::Helper::Api.new.connection

      if self.class.name == "CloudstackSpec::Resource::Zone"
        @zonename = this_zone(name)
      end
    end

    def to_s
      type = self.class.name.split(':')[-1]
      type.gsub!(/([a-z\d])([A-Z])/, '\1 \2')
      #type.capitalize!
      %Q!#{type} "#{@name}"!
    end

    def inspect
      to_s
    end

    def to_ary
      to_s.split(" ")
    end

    def get_zone(zonename=nil)
      if zonename.nil?
        zone = @connection.list_zones['zone'].first
        #zonename = zonename['name']
      else 
        #zonename = zonename
        zone = @connection.list_zones(:name => zonename)['zone'].first
      end
        return zone
    end

    def job_status?(jobid)
        job = @connection.query_async_job_result(jobid: jobid)
      until job['jobstatus'] != 0
        puts "  async job in progress..."
        job = @connection.query_async_job_result(jobid: jobid)
        sleep(5)
      end
      if job['jobresultcode'] == 0
        sleep(5)
        return true
      else
        return false
      end
    end

  end
end