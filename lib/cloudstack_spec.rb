require 'rspec'
require 'rspec/its'
require 'specinfra'
require 'cloudstack_spec/version'
require 'cloudstack_spec/resource'
require 'cloudstack_spec/helper'
require 'cloudstack_spec/matcher'
require 'cloudstack_spec/setup'
require 'cloudstack_spec/resource/base'


module CloudstackSpec

  #output the url + version under test
  @client = CloudstackSpec::Helper::Api.new
  puts "Testing system:     #{@client.url}"
  puts "CloudStack version: #{@client.version}"
  puts "executed at:        " + Time.now.to_s

end

class String
  def to_snake_case
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def to_camel_case
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    split('_').map{|e| e.capitalize}.join
  end
end

module RSpec::Core::Notifications
  class FailedExampleNotification 
    def failure_lines
      @failure_lines ||=
        begin
          lines = []
#          lines << "On host `#{host}'" if host
          lines << "Failure/Error: #{read_failed_line.strip}"
#          lines << "#{exception_class_name}:" unless exception_class_name =~ /RSpec/
          exception.message.to_s.split("\n").each do |line|
            lines << "  #{line}" if exception.message
          end
#          lines << "  #{example.metadata[:command]}"
#          lines << "  #{example.metadata[:stdout]}" if example.metadata[:stdout]
#          lines << "  #{example.metadata[:stderr]}" if example.metadata[:stderr]
#          lines
        end
    end
  end
end