$:.unshift File.dirname(__FILE__)
require 'generator_mixin'

module Graphiti
  class ApiTestGenerator < ::Rails::Generators::Base
    include GeneratorMixin

    source_root File.expand_path('../templates', __FILE__)

    argument :resource, type: :string
    class_option :actions,
      type: :array,
      default: nil,
      aliases: %w[-a],
      desc: 'Array of controller actions, e.g. "index show destroy"'

    desc 'Generates rspec request specs at spec/api'
    def generate
      %w[index show create update destroy].each do |action|
        next unless actions?(action)

        to = File.join("spec", ApplicationResource.endpoint_namespace, dir, "#{action}_spec.rb"
        template("#{action}_request_spec.rb", to)
      end
    end

    private

    def var
      resource_name.gsub('/', '_')
    end

    def dir
      resource_name.pluralize
    end

    def resource_name
      @resource.gsub('Resource', '').underscore
    end

    def resource_class
      @resource.constantize
    end

    def type
      resource_class.type
    end

    def model_class
      resource_class.model
    end
  end
end
