require 'spec_helper'

#  describe virtual_machine('bling-bling3') do
#    it { should be_created }
#     it { should exist }
#    describe snapshot do
#      it { should be_created }
#      it { should exist }
#    end
#    it { should be_running }
#    #its(:open_pf_ssh) { should be_set }
#  end
  


describe template_from_snapshot('bling-bling3') do
  it { should be_created }
end

describe virtual_machine('bling-bling4') do
  subject do
    vm_from_template = CloudstackSpec::Resource::VirtualMachine.new('bling-bling4')
    vm_from_template.template_name << 'bling-bling3'
    vm_from_template
  end
  it { should be_created }
end