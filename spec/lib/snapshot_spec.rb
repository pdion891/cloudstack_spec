require 'spec_helper'


describe vpc('spec-vpc1') do
  it { should be_created }
  it { should exist }
  it { should be_reachable }

  describe vpc_tier('tier11') do
    it { should be_created }
    it { should exist }
  end

  describe virtual_machine('bling-bling1') do
    it { should be_created }
     it { should exist }
    it { should be_running }
    describe snapshot do
      it { should be_created }
      it { should exist }
    end
  end

end

describe template_from_snapshot('bling-bling1') do
  it { should be_created }
end

describe virtual_machine('bling-bling2') do
  subject do
    vm_from_template = CloudstackSpec::Resource::VirtualMachine.new('bling-bling2')
    vm_from_template.template_name << 'bling-bling1'
    vm_from_template
  end
  it { should be_created }
end




