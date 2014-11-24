# API call to Apache CloudStack
module CloudstackSpec::Helper
  class Api
    def connection
      configs     = YAML.load_file("spec/config.yml")
      _url        = configs['cloudstack']['url']
      _api_key    = configs['cloudstack']['api_key']
      _secret_key = configs['cloudstack']['secret_key']
      _use_ssl    = configs['cloudstack']['use_ssl']
      @client     = CloudstackRubyClient::Client.new(
                    "#{_url}",
                    "#{_api_key}",
                    "#{_secret_key}", 
                    _use_ssl)
    end
  
    def connection2
      configs     = YAML.load_file("spec/config.yml")
      _url        = configs['cloudstack']['url']
      _use_ssl    = configs['cloudstack']['use_ssl']
      _api_key    = $api_key
      _secret_key = $secret_key
      @client     = CloudstackRubyClient::Client.new(
                    "#{_url}",
                    "#{_api_key}",
                    "#{_secret_key}", 
                    _use_ssl)
    end

    def url
      connection.instance_variable_get(:@api_url)
    end
    
    def version
      connection.list_capabilities["capability"]["cloudstackversion"]
    end
  end
end


