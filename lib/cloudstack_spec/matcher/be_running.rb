RSpec::Matchers.define :be_ready do |expected|
  match do |actual|
    actual.running? == true
  end

  failure_message do |actual|
    "#{actual} status: #{actual.ready?}"
  end
 
  description do
    "be running"
  end

  failure_message_when_negated do |actual|
    "not be running"
  end
end