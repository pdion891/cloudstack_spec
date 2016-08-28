module CloudstackSpec
  module Resource
    class Configuration
      include Base

      def initialize(params={})
        params.each { |key, value| instance_variable_set("@#{key}", value) }
        set_defaults
        @connection = CloudstackSpec::Helper::Api.new.connection
        @zone = get_zone(zonename ||= nil)
      end

    end
  end
end
