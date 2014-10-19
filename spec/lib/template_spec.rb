# test collection against zone to confirm it is ready to work.
#

require 'spec_helper'
#require 'cloudstack_spec'
#require 'cloudstack_spec/resource/template'

#describe "zone" do
#  it "should have one zone enabled" do
#    connection
#    zone = @client.list_zones(:allocationstate => "Enabled")
#    expect(zone["count"]).to  be >= 1
#  end
#end
#
#describe "infrastructure" do 
#  it "should have 2 system vm running" do
#    connection
#    sysvm = @client.list_system_vms(:state => "Running")
#    expect(sysvm["count"]).to eq(2)
#  end
#  it "should have managed hosts" do
#    connection
#    hosts = @client.list_hosts(:state => "Up")
#    expect(hosts["count"]).to be >=1
#  end
#end

#describe "base template" do
#	it "should have a vm template ready" do

#describe template('CentOS 5.6(64-bit) no GUI (XenServer)') do
#describe CloudstackSpec::Resources::Template do
  #it { should exist }
#end

describe CloudstackSpec::Resource::Template.new("CentOS 5.6(64-bit) no GUI (XenServer)") do
  it { should exist }
  #it { should be_ready }

end

describe template('CentOS') do
  it { should exist }
  #it { should be_ready }

end