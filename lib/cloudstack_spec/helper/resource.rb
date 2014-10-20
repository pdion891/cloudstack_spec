module CloudstackSpec
  module Helper
    module Resource
      resources = %w(
        base template zone system_vm network
      )

      resources.each {|resource| require "cloudstack_spec/resource/#{resource}" }

      resources.each do |resource|
        define_method resource do |*args|
          name = args.first
          eval "CloudstackSpec::Resource::#{resource.to_camel_case}.new(name)"
        end
      end
    end
  end
end