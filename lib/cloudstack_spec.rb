require "cloudstack_spec/version"
#require 'serverspec/helper'
require 'cloudstack_spec/resource'
require 'cloudstack_spec/helper'
require 'cloudstack_spec/resource/base'


module CloudstackSpec
  # Your code goes here...
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