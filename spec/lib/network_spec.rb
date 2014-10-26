require 'spec_helper'

describe network("test1") do
  it { should exist }
  it { should be_ready }
end


describe vpc('patate') do

  it { should exist }
  it { should be_ready }
  it { should be_reachable }

  describe network('tier41') do
    subject do
      network = CloudstackSpec::Resource::Network.new('tier41')
      network.vpcname << 'patate'
      network
    end
    it { should exist }
  end

end

#  describe network('tier41') do
#    it { should exist }
#  end



#describe network('tier41', 'patate') do
#  let(:network) { network.vpcname << 'patate'}
#  it { should exist }
#end
#describe vpc('test4') do
#  it { should be_created }
#  it { should be_ready }
#  it { should be_reachable }

#end