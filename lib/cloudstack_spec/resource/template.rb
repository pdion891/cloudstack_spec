module CloudstackSpec::Resource
    class Template < Base
      # do nothing

      def exist?
        begin
          template = connection.list_templates(:templatefilter => "all", "name"=> name)
          if template['count'].nil?
            return false
          else
            return true
          end
        rescue Exception => e
          return false
        end
      end
      #def ready?
      #	if zone.nil?
      #		template = @connection.list_templates(:templatefilter => "all", "name"=> name)
      #	return true
      #end
    end
end
