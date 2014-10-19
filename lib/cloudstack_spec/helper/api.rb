# API call to Apache CloudStack
module CloudstackSpec::Helper
  class Api
    def connection
      configs     = YAML.load_file("spec/config.yml")
      _host       = configs['cloudstack']['host']
      _port       = configs['cloudstack']['port']
      _admin_port = configs['cloudstack']['admin_port']
      _api_key    = configs['cloudstack']['api_key']
      _secret_key = configs['cloudstack']['secret_key']
      @client     = CloudstackRubyClient::Client.new(
                    "http://#{_host}:#{_port}/client/api",
                    "#{_api_key}",
                    "#{_secret_key}")
    end
  
    def url
      connection.instance_variable_get(:@api_url)
    end
    
    def version
      connection.list_capabilities["capability"]["cloudstackversion"]
    end
  end
end


