RSpec::Matchers.define :be_set do
  match do |actual|
    actual == true
  end

  failure_message do |actual|
    "be enabled, return: #{actual}"
  end
 
  description do
    "be enabled"
  end

  failure_message_when_negated do |actual|
    "not be enabled"
  end

end