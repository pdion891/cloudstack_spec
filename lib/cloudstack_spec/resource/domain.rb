module CloudstackSpec::Resource
  class Domain < Base
    # handle domain objects.

    def initialize(name=nil)
      @name   = name
      @connection = CloudstackSpec::Helper::Api.new.connection

      $domainid = domain_id
    end

    def exist?
      begin
        if domain.empty?
          return false
        else
          return true
        end
      rescue Exception => e
        return false
      end
    end

    def created?
      if self.exist?
        puts "  Domain already exist"
        return true
      else
        domain = @connection.create_domain(name: @name)
        $domainid = domain_id
      end
    end

    def destroy?
      sleep(5)
      if self.exist?
        job = @connection.delete_domain(id: domain_id)
        return job_status?(job['jobid'])
      else
        puts "  Domain does not exist"
        return false
      end

    end


    private

      def domain
        domains = @connection.list_domains(listall: true, name: @name)
        domain = domains['domain'].first
        if domain.nil?
          return {}
        else
          return domain
        end
      end

      def domain_id
        domain = @connection.list_domains(listall: true, name: @name)
        if domain.nil? || domain.empty?
          return ""
        else
          domain['domain'].first['id']
          return domain['domain'].first['id']
        end
      end

  end
end

