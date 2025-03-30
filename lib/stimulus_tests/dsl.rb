require "stimulus_tests/visit_controller"

module StimulusTests
  module DSL
    extend ::ActiveSupport::Concern

    class_methods do
      def layout(layout)
        @layout = layout
      end

      def importmap_entry_point(importmap_entry_point = nil)
        @importmap_entry_point = importmap_entry_point
      end
    end

    # TODO: is there a better method name that `visit_html`? Something that clearly explains you can give a block that's
    # evaluated in a view, and the HTML string it produces will be rendered into the page.
    def visit_html(html = nil, layout: UNDEFINED, importmap_entry_point: UNDEFINED, &render_block)
      if html && block_given?
        raise ArgumentError, "only one of `html:` or a block are allowed, not both"
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

    included do
      teardown { VisitController._teardown }
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
