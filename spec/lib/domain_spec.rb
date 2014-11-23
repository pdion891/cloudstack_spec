require 'spec_helper'

describe domain("test44") do
  it { should be_created }
  it { should exist }
#  it { should be_destroy }

  describe account('joeblow') do
    it { should be_created }
    it { should exist }
    its(:registerUserKeys) { should be_set }
  end

end

