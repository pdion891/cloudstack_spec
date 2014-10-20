RSpec::Matchers.define :be_created do |expected|
  match do |actual|
    if UUID.validate(actual.created) == true
      connection
      jobstatus = @connection.query_async_job_result(jobid: actual)['jobstatus']
      until jobstatus != 0
        jobstatus = @connection.query_async_job_result(jobid: actual)['jobstatus']
        sleep(5)
      end
      jobstatus == 1
    else
      false
    end
  end

  failure_message do |actual|
    "#{actual} status: #{actual.created}"
  end
 
  description do
    "#{actual} be running, #{actual.created}"
  end

  failure_message_when_negated do |actual|
    "not be running"
  end

end