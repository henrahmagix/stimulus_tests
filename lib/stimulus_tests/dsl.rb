require "stimulus_tests/visit_controller"

module StimulusTests
  module DSL
    extend ::ActiveSupport::Concern

    class MissingTestFramework < StandardError; end

    included do
      if respond_to?(:teardown)
        teardown { VisitController._teardown }
      elsif defined?(RSpec) && respond_to?(:after)
        after { VisitController._teardown }
      else
        raise MissingTestFramework, "StimulusTests::DSL cannot be included on #{self}: it expects a teardown method to be available."
      end
    end

    class_methods do
      def layout(layout)
        @layout = layout
      end

      def importmap_entry_point(importmap_entry_point = nil)
        @importmap_entry_point = importmap_entry_point
      end
    end

    def render_stimulus(html = nil, layout: UNDEFINED, importmap_entry_point: UNDEFINED, &render_block)
      if html && block_given?
        raise ArgumentError, "Both a HTML string or a block are not allowed, please give one or the other. A string is simpler, whilst a block allows you to use view helpers."
      end

      layout                = defined_or_default(layout,                self.class.instance_variable_get(:@layout))
      importmap_entry_point = defined_or_default(importmap_entry_point, self.class.instance_variable_get(:@importmap_entry_point))

      VisitController._setup(
        layout:,
        importmap_entry_point:,
        html:,
        render_block:,
      )

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
