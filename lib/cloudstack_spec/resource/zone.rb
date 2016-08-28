module CloudstackSpec
  module  Resource
    # All about zone...
    #####
    class Zone
      include Base
      attr_reader :name

      def initialize(name = 'rspec-zone1')
#        params.each { |key, value| instance_variable_set("@#{key}", value) }
        @connection = CloudstackSpec::Helper::Api.new.connection
        @runner = Specinfra::Runner
        @zone = get_zone(name)
        @name = name ? name : @zone['name']
        $zone = @zone
      end

      def exist?
        #zone = @connection.list_zone(:name => name)
        @zone.empty? ? false : true
      end

      def allocated?
        if @zone['allocationstate'] == 'Enabled'
          true
        else
          @zone['allocationstate']
        end
      end

      def local_storage
        @zone['localstorageenabled']
      end

      def security_group
        @zone['securitygroupsenabled']
      end

      def network_type
        @zone['networktype']
      end

    end
  end
end
