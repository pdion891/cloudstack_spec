require 'spec_helper'
require 'pry'

describe zone do
  it { should exist }
  it { should be_allocated }
  its(:local_storage) { should be_set }
  its(:security_group) { should_not be_set }
  its(:network_type) { should match("Advanced") }
end


#describe virtual_machine('test1') do
#  it { should exist }
#  it { should be_running }
#  it { should_not be_reachable }
#end

describe virtual_machine('bling-bling1') do
  it { should be_created }
  it { should be_running }
  it { should_not be_reachable }
#  it { should be_destroy }
end
