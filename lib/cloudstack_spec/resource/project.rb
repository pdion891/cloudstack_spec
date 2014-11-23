module CloudstackSpec::Resource
  class Project < Base
    # handle domain objects.

    def exist?
      begin
        if project.empty?
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
        puts "  Project already exist"
        return true
      else
        account = @connection.create_project(
          displaytext: @name,
          name: @name)
      end
    end

    def destroy?
      sleep(5)
      if self.exist?
        job = @connection.delete_account(id: account_id)
        return job_status?(job['jobid'])
      else
        puts "  Account does not exist"
        return false
      end

    end

    def registerUserKeys
      keys = @connection.register_user_keys(id: user_id)
      puts "      apikey    = #{keys["userkeys"]['apikey']}"
      puts "      secretkey = #{keys["userkeys"]['secretkey']}"
      return true
    end



    private

      def project
        projects = @connection.list_projects(listall: true, name: @name)
        project = projects['project'].first
        if project.nil?
          return {}
        else
          return project
        end
      end

      def project_id
        proj = project
        if proj.nil?
          return ""
        else
          return proj['project'].first['id']
        end
      end

  end
end

