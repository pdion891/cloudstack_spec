require 'spec_helper'


describe vpc('spec-vpc1') do
#  it { should be_created }
  it { should exist }
#  it { should be_ready }
#  it { should be_reachable }
#  its(:enable_remote_vpn) { should be_set }
#  its(:remote_vpn_enabled?) { should be }

  describe vpc_tier('tier11') do
#    subject do
#      vpc_tier = CloudstackSpec::Resource::Network.new('tier11')
#      vpc_tier.vpcname << 'spec-vpc1'
#      vpc_tier
#    end
    it { should be_created }
    it { should exist }
  end

end
