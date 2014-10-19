# If the zone is allocated (Enabled)

RSpec::Matchers.define :be_allocated do |expected|
  match do |actual|
    actual.allocated? == true
  end

  failure_message do |actual|
    "status: #{actual.allocated?}"
  end
 
  description do
    "be allocated (Enabled)"
  end

  failure_message_when_negated do |actual|
    "Status: #{actual}"
  end

  chain :with_level do |level|
    @level = level
  end
end