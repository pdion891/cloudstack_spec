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
#    it { should be_reachable }
  end
end

describe template("CentOS 5.6(64-bit) no GUI (XenServer)") do
  it { should exist }
  it { should be_ready }
end

describe template('Ubuntu 14.04 LTS') do
  it { should exist }
  it { should be_ready }
end

describe vpc('spec-vpc1') do
#  it { should be_created }
  it { should exist }
#  it { should be_ready }
  it { should be_reachable }
#  its(:enable_remote_vpn) { should be_set }
  its(:remote_vpn_enabled?) { should be }

  describe network('tier11') do
    subject do
      network = CloudstackSpec::Resource::Network.new('tier11')
      network.vpcname << 'spec-vpc1'
      network
    end
#    it { should be_created }
    it { should exist }
  end

  describe virtual_machine('bling-bling1') do
#    it { should be_created }
 #   describe snapshot do
 #     it { should be_created }
 #     it { should exist }
 #   end
    it { should be_running }
  #  it { should be_destroy }
  end


  #  its(:open_pf_ssh) { should be_set }
  #  its(:pf_open_check) { should be_reachable }
end

#describe template_from_snapshot('bling-bling1') do
  #it { should be_created }
#end

describe virtual_machine('bling-bling2') do
  subject do
    vm_from_template = CloudstackSpec::Resource::VirtualMachine.new('bling-bling2')
    vm_from_template.template_name << 'bling-bling1'
    vm_from_template
  end
  it { should be_created }
end




