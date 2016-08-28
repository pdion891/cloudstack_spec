module CloudstackSpec
  module Resource
    #
    # Base methods for resource classes
    #
    module Base

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

      def get_zone(zonename = nil)
        puts zonename
        if zonename.nil?
          @connection.list_zones['zone'].first
        else
          @connection.list_zones(:name => zonename)['zone'].first
        end
      rescue
        # if not found return empty instead of nil
        ""
      end

      def job_status?(jobid)
          job = @connection.query_async_job_result(jobid: jobid)
          print "  async job in progress..."
        until job['jobstatus'] != 0
          print '.'
          job = @connection.query_async_job_result(jobid: jobid)
          sleep(5)
        end
          puts ''
        if job['jobresultcode'] == 0
          sleep(5)
          true
        else
          false
        end
      end

    end
  end
end