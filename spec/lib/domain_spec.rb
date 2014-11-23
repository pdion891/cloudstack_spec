require 'spec_helper'

describe domain("test44") do
  it { should be_created }
  it { should exist }
  it { should be_destroy }
end

