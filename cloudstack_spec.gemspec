# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloudstack_spec/version'

Gem::Specification.new do |spec|
  spec.name          = "cloudstack_spec"
  spec.version       = CloudstackSpec::VERSION
  spec.authors       = ["Pierre-Luc Dion"]
  spec.email         = ["pdion891@apache.org"]
  spec.summary       = %q{RSpec tests for Apache CloudStack.}
  spec.description   = %q{Servespec like tests for Apache CloudStack using Rspec.}
  spec.homepage      = "https://github.com/pdion891/cloudstack_spec"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "yaml"
  spec.add_runtime_dependency "rspec-its"
  spec.add_runtime_dependency "uuid"
  spec.add_runtime_dependency "cloudstack_ruby_client", "~> 1.0.2"

end
