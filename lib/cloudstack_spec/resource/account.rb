module CloudstackSpec::Resource
  class Account < Base
    # handle domain objects.

    def exist?
      begin
        if account.empty?
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
        puts "  Account already exist"
        return true
      else
        account = @connection.create_account(
          accounttype: 0,
          email: 'nothing@apache.org',
          firstname: 'cloudstack_spec',
          lastname: 'cloudstack_spec',
          password: 'password',
          domainid: $domainid ,
          username: @name)
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
      keys = user_keys
      puts "      apikey    = #{keys['apikey']}"
      puts "      secretkey = #{keys['secretkey']}"
      return true
    end



    private

      def account
        accounts = @connection.list_accounts(listall: true, name: @name)
        accounts = accounts['account'].first
        if accounts.nil?
          return {}
        else
          return accounts
        end
      end

      def account_id
        account = @connection.list_accounts(listall: true, name: @name)
        if account.nil?
          return ""
        else
          return account['account'].first['id']
        end
      end

      def user_keys
        user = account
        if user.empty?
          return ''
        else
          user = user['user'].first
          if user['apikey'].nil? or user['apikey'].empty?
            keys = @connection.register_user_keys(id: user_id)
            keys = keys['userkeys']
          else
            keys = {'apikey' => user['apikey'], 'secretkey' => user['secretkey']}
          end
          return keys
        end
      end

      def user_id
        if self.exist?
          userid = @connection.list_accounts(listall: true, name: @name)
          userid = userid['account'].first['user'].first['id'] 
          return userid
        else
          return ""
        end
      end
  end
end

