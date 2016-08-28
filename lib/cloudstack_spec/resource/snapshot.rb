module CloudstackSpec::Resource
  class Snapshot
    include Base

    def initialize(name='root_disk')
      @volume_name = name
      @connection = CloudstackSpec::Helper::Api.new.connection
      @version = CloudstackSpec::Helper::Api.new.version
    end

  def exist?
    snapshots = @connection.list_snapshots(volumeid: get_volume_id)
    if ! snapshots.empty?
      if snapshots['count'] >= 1
        return true
      end
    else
      return false
    end
  end

  def created?
    # start the VM creation job
    # Return {true/false}
    #if self.exist?
    #  creation_job = "Already exist" 
    #  puts "    #{creation_job}"
    #  return false
    #end
    begin
      newsnap = @connection.create_snapshot(volumeid: get_volume_id)
      creation_job = newsnap['jobid']
    rescue Exception => e
      creation_job = "vm creation fail with #{e.message}"
    end
    if UUID.validate(creation_job) == true
      puts "  jobid: #{creation_job}"
      return job_status?(creation_job)
    else
      puts "  #{creation_job}"
      return false
    end
  end


  private
    def get_volume_id
      vol = @connection.list_volumes(virtualmachineid: $vm['id'])
      vol = vol['volume'].first
      return vol['id']
    end

  end
end