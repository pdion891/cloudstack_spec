# Subject type helper
require 'cloudstack_spec/helper/resource'
require 'cloudstack_spec/helper/api'

extend CloudstackSpec::Helper::Resource
class RSpec::Core::ExampleGroup
  extend CloudstackSpec::Helper::Resource
  include CloudstackSpec::Helper::Resource
end