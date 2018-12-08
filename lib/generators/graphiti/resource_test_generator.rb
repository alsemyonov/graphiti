$:.unshift File.dirname(__FILE__)
require 'generator_mixin'

module Graphiti
  class ResourceTestGenerator < ::Rails::Generators::Base
    include GeneratorMixin

    source_root File.expand_path('../templates', __FILE__)

    argument :resource, type: :string
    argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
    class_option :actions,
      type: :array,
      default: nil,
      aliases: %w[-a],
      desc: 'Array of controller actions, e.g. "index show destroy"'

    desc 'Generates rspec request specs at spec/api'
    def generate
      if actions?('create', 'update', 'destroy')
        to = "spec/resources/#{resource_name}/writes_spec.rb"
        template('resource_writes_spec.rb', to)
      end

      if actions?('index', 'show')
        to = "spec/resources/#{resource_name}/reads_spec.rb"
        template('resource_reads_spec.rb', to)
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
