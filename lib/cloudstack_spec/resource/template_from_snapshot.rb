module CloudstackSpec::Resource
  class TemplateFromSnapshot < Base
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

    def created?
      if self.exist?
        return 'template already exist'
      else
        snapshot = get_snapshot
        if ! snapshot.empty?
          new_template = @connection.create_template(
                    name: @name, 
                    displaytext: @name,
                    ostypeid: get_vm['ostypeid'],
                    passwordenabled: 'true',
                    snapshotid: get_snapshot['id']
                  )
          creation_job = new_template['jobid']
        end
      end
    end


    private

      def get_vm
        vm = @connection.list_virtual_machines(name: @name)
        vm = vm['virtualmachine'].first
        return vm
      end

      def get_volume
        vol = @connection.list_volumes(virtualmachineid: get_vm['id'])
        return vol['volume'].first
      end

      def get_snapshot
        snapshot = @connection.list_snapshots(volumeid: get_volume['id'])
        return snapshot['snapshot'].first
      end

  end
end