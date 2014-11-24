# CloudstackSpec

...Work In Progress...

[Apache CloudStack](http://cloudstack.apache.org/) test framework based on Rspec library. Similar to [serverspec](http://serverspec.org/) it is used to test and validate CloudStack installation and configurations.


## Installation

install as gem:

    $ gem install cloudstack_spec

Create a test repo folder:
  
    $ mkdir my_cloudstack_spec
    $ cd my_cloudstack_spec

Initialize cloudstack_spec:

    $ cloudstackspec-init
    Create base for cloudstack_spec? y/n: y
     + spec/
     + spec/lib/
     + spec/config.yml
     + spec/lib/001_zone_spec.rb
     + spec/spec_helper.rb
    Make sure to Update file: spec/config.yml
    $

or

Clone this repo:

    $ git clone https://github.com/pdion891/cloudstack_spec.git
    $ cd cloudstack_spec


## Configuration

Update ``spec/config.yml`` to reflect your environment

```yaml
cloudstack:
  url:        http://[cloustack_management_ip]:8080/client/api
  api_key:    rkVsYauTGYkR2I0aX3Qmh4s3cfdtR5LNnw7cNKCpHnzKsA-zaXUn7k__fbBga-l0BQl9Qlmq57tkaj67L7W_bg
  secret_key: dS0grBtPMbg5PTr62VLeApd55pssU5fObcW-hmGjiUNyBWw67BRPWRJrXQ5OfO0LTzLRdN-pHiDz25K1o3qLeA
  use_ssl:    false
```

## Usage

Create test definition file in ``spec/lib/[test]_spec.rb`` as example in the directory.

### test example

```spec
require 'spec_helper'

describe zone do
  it { should exist }
  it { should be_allocated }
  its(:local_storage) { should be_set }
  its(:security_group) { should_not be_set }
  its(:network_type) { should match("Advanced") }
end

%w(consoleproxy secondarystoragevm).each do |svm|
  describe system_vm(svm) do
    it { should exist }
    it { should be_running }
    it { should be_reachable }
  end
end

```

### Execute test run

Simply run ``rspec`` or define test case file as follow:

```bash
rspec spec/lib/[test_scenario]_spec.rb

#ex:

rspec spec/lib/001_zone_spec.rb
```

Output example:

    $ rspec spec/lib/1_zone_spec.rb
    Testing system:     http://123.123.123.123:8080/client/api
    CloudStack version: 4.4.1
    executed at:        2014-11-16 19:28:49 -0500
    
    Zone "preprod2_zone1"
      should exist
      should be allocated (Enabled)
      local_storage
        should be enabled
      security_group
        should not be enabled
      network_type
        should match "Advanced"
    
    System Vm "consoleproxy"
      should exist
      should be running
      should be reachable
    
    System Vm "secondarystoragevm"
      should exist
      should be running
      should be reachable
    
    Finished in 2.24 seconds (files took 1.2 seconds to load)
    11 examples, 0 failures


## Contributing

1. Fork it ( https://github.com/pdion891/cloudstack_spec/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
