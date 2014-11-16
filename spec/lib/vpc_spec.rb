require 'spec_helper'

describe vpc('spec-vpc1') do
  it { should be_created }
  it { should exist }
  it { should be_ready }
  it { should be_reachable }
  its(:enable_remote_vpn) { should be_set }
  its(:remote_vpn_enabled?) { should be }

  describe vpc_tier('tier11') do
    it { should be_created }
    it { should exist }

    describe virtual_machine('bling-bling1') do
      it { should be_created }
      it { should_not be_reachable } # internal IP of the VM should not be reachable
      it { should exist }
      it { should be_running }
      its(:open_pf_ssh) { should be_set }
      context 'With port forwarding' do
        it { should be_reachable.with( :port => 22, :proto => 'tcp' ) }
      end
    end

  end
end


# Delete everything
describe virtual_machine('bling-bling1') do
  it { should be_destroy }
end

describe vpc_tier('tier11') do
  it { should be_destroy }
end

describe vpc('spec-vpc1') do
  it { should be_destroy }
end
