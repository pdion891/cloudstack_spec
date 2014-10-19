module CloudstackSpec::Resource
  class Template < Base
    # do nothing

    def tpl
      @connection.list_templates(:templatefilter => "all", :name => name)
    end

    def exist?
      begin  
        if tpl['count'].nil?
          return false
        else
          return true
        end
      rescue Exception => e
        return false
      end
    end

    def ready?
      if ! tpl["count"].nil?
        isready = tpl["template"].first["isready"]
        if isready
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
