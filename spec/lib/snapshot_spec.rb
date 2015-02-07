require 'spec_helper'


describe vpc('spec-vpc2') do
  it { should be_created }
  it { should exist }
  it { should be_reachable }

  describe vpc_tier('tier2') do
    it { should be_created }
    it { should exist }
  end

  describe virtual_machine('test-vm1') do
    it { should be_created }
     it { should exist }
    it { should be_running }
    describe snapshot do
      it { should be_created }
      it { should exist }
    end
  end

end

describe template_from_snapshot('test-vm1') do
  it { should be_created }
end

describe virtual_machine('bling-bling2') do
  subject do
    vm_from_template = CloudstackSpec::Resource::VirtualMachine.new('bling-bling2')
    vm_from_template.template_name << 'test-vm1'
    vm_from_template
  end
  it { should be_created }
end




