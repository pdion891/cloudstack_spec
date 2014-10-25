RSpec::Matchers.define :created do |expected|
  match do |actual|
    #UUID.validate(actualz) == true
    #puts "actual = #{actual}"
    #puts "#{actual.name}"
    #if UUID.validate(actual.is_created?) == true
    #  jobstatus = @connection.query_async_job_result(jobid: actual)['jobstatus']
    #  until jobstatus != 0
    #    jobstatus = @connection.query_async_job_result(jobid: actual)['jobstatus']
    #    sleep(5)
    #  end
    #  jobstatus == 1
    #else
    #  false
    #end
  end

  failure_message do |actual|
    "#{actual} status: #{actual.is_creating}"
  end
 
  description do
    "#{actual} be created, #{actual.is_creating}"
  end

  failure_message_when_negated do |actual|
    "VM creation not should not be possible"
  end

end