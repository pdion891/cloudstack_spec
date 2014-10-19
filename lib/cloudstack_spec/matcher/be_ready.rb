RSpec::Matchers.define :be_ready do |expected|
  match do |actual|
    actual.ready? == true
  end

  failure_message do |actual|
    "template status: #{actual.ready?}"
  end
 
  description do
    "be ready"
  end

#  failure_message_when_negated do |actual|
#    "template status: #{actual}"
#  end
end