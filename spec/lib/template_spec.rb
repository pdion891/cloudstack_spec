require 'spec_helper'

describe template("CentOS 5.6(64-bit) no GUI (XenServer)") do
  it { should exist }
  it { should be_ready }
end

describe template('Ubuntu 14.04 LTS') do
  it { should exist }
  it { should be_ready }
end