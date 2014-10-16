module CloudstackSpec
  module Helper
    module Resource
      resources = %w(
        template
      )

      resources.each {|resource| require "cloudstack_spec/resource/#{resource}" }

      resources.each do |resource|
        define_method resource do |*args|
          name = args.first
          eval "CloudstackSpec::Resource::#{resource.capitalize}.new(name)"
        end
      end
    end
  end
end