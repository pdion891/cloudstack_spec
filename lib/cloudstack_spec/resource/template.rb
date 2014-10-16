module CloudstackSpec
  module Resource
    class Template < Base
      # do nothing
      	#@template = @connection.list_templates(:templatefilter => "all", "name"=> name)
      def exist?
      	@template = @connection.list_templates(:templatefilter => "all", "name"=> name)
      	unless @template['count'].nil?
        	return true
        else
        	return false
        end
      end
      def ready?
      	if zone.nil?
      		if @template['template'].first['isready']  
      			return true
      		else
      			return false
      		end
      	end
      end
    end
  end
end