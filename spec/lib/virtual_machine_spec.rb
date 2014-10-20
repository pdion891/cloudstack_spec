require 'spec_helper'


describe virtual_machine('test1') do
  it { should exist }
  it { should be_running }
  it { should_not be_reachable }
end