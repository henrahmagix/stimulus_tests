require "stimulus_tests/controller_configuration"
require "stimulus_tests/render_controller"

module StimulusTests
  module DSL
    class MissingTestFrameworkError < StandardError; end

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        if respond_to?(:teardown)
          teardown { RenderController._teardown }
        elsif defined?(RSpec) && respond_to?(:after)
          after { RenderController._teardown }
        else
          raise MissingTestFrameworkError, "StimulusTests::DSL cannot be included on #{self}: it expects a teardown method to be available."
        end
      end
    end

    module ClassMethods
      def layout(layout)
        @layout = layout
      end

      def import(import = nil)
        @import = import
      end
    end

    def render_stimulus(html = nil, layout: UNDEFINED, import: UNDEFINED, &render_block)
      if html && block_given?
        raise ArgumentError, "Both a HTML string or a block are not allowed, please give one or the other. A string is simpler, whilst a block allows you to use view helpers."
      end

      layout = defined_or_default(layout, self.class.instance_variable_get(:@layout))
      import = defined_or_default(import, self.class.instance_variable_get(:@import))

      RenderController._setup ControllerConfiguration.new(layout:, import:, html:, render_block:)

      visit ::Rails.application.config.stimulus_tests.route_path
    end

    private

      UNDEFINED = "__undefined__".freeze

      def defined_or_default(value, default)
        if value == UNDEFINED
          default
        else
          value
        end
      end
  end
end
