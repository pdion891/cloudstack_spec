require 'spec_helper'

describe domain("domainX") do
  it { should be_created }
  it { should exist }
#  it { should be_destroy }

  describe account('joeblow') do
    it { should be_created }
    it { should exist }
    its(:registerUserKeys) { should be_set }
  end

  describe project('projectX') do
    it { should be_created }
    it { should exist }
  end
end
