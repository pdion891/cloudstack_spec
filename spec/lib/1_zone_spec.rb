require 'spec_helper'

describe zone do
  it { should exist }
  it { should be_allocated }
  its(:local_storage) { should be_set }
  its(:security_group) { should_not be_set }
  its(:network_type) { should match("Advanced") }
end

%w(consoleproxy secondarystoragevm).each do |svm|
  describe system_vm(svm) do
    it { should exist }
    it { should be_running }
    it { should be_reachable }
  end
end

