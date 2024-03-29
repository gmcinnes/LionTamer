require 'chef/resource/script'

class Chef
  class Resource
    class Homebrew < ::Chef::Resource::Package
      def initialize(name, run_context = nil)
        super(name, run_context)
        @resource_name = :homebrew
        @provider      = Chef::Provider::Package::Homebrew
        @allowed_actions = [ :install, :remove ]
      end
    end
  end
end
