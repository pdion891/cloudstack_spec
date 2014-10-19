RSpec::Matchers.define :be_allocated do |expected|
  match do |actual|
    actual.allocated? == true
  end

  failure_message do |actual|
    "status: #{actual.allocated?}"
  end
 
  description do
    "be enabled and ready to be use"
  end

  failure_message_when_negated do |actual|
    "Status: #{actual}"
  end
end