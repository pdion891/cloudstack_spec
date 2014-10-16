module CloudstackSpec
  module Resource
    class Base
      # do nothing
      def initialize(name=nil)
        @name   = name
        #@runner = Specinfra::Runner
        @connection = connection
      end
      def name
        self.class.name.split('::').last[0...(-1 * 'Resource'.size)]
      end


      def context_class
        Contexts.const_get("#{name}Context")
      end

      def connection
        configs     = YAML.load_file("spec/config.yml")
        _host       = configs['cloudstack']['host']
        _port       = configs['cloudstack']['port']
        _admin_port = configs['cloudstack']['admin_port']
        _api_key    = configs['cloudstack']['api_key']
        _secret_key = configs['cloudstack']['secret_key']
        @client     = CloudstackRubyClient::Client.new \
                      "http://#{_host}:#{_port}/client/api",
                      "#{_api_key}",
                      "#{_secret_key}"
      end
    end
  end
end