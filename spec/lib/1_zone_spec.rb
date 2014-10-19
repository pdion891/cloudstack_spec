require 'spec_helper'

describe zone do
  it { should exist }
  it { should be_allocated }
  its(:local_storage) { should be_enabled }
  its(:security_group) { should_not be_enabled }
  its(:network_type) { should match("Advanced") }
end
