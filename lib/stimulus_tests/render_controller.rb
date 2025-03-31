module StimulusTests
  class RenderController < ::ActionController::Base
    DEFAULT_LAYOUT = "stimulus_tests".freeze

    before_action :make_default_layout_available
    after_action :insert_js_import

    def index
      unless self.class.prepared
        raise VisitedWithoutSetup, "The StimulusTests route #{request.path.inspect} was visited without being setup correctly. Please use `render_stimulus` e.g. `render_stimulus('<p>Hello</p>')`"
      end

      render layout: prepared_layout, html: prepared_content.html_safe
    end

    class VisitedWithoutSetup < ::StandardError; end

    Preparation = Struct.new(:layout, :importmap_entry_point, :render_block, :html, keyword_init: true)

    class << self
      attr_reader :prepared, :preparation

      def _setup(layout:, importmap_entry_point:, render_block:, html:)
        @prepared = true
        @preparation = Preparation.new(layout:, importmap_entry_point:, render_block:, html:)
      end

      def _teardown
        @prepared = false
      end
    end

    private

      delegate :javascript_importmap_tags, to: :view_context

      def make_default_layout_available
        append_view_path File.expand_path(File.join(__dir__, "../../app/views"))
      end

      def insert_js_import
        return unless prepared_importmap_entry_point

        insert_position = response.body.index("</head>") || 0
        js_import       = javascript_importmap_tags(prepared_importmap_entry_point)

        response.body = response.body.insert(insert_position, js_import)
      end

      def prepared_layout                = self.class.preparation.layout || DEFAULT_LAYOUT
      def prepared_importmap_entry_point = self.class.preparation.importmap_entry_point
      def prepared_render_block          = self.class.preparation.render_block
      def prepared_html                  = self.class.preparation.html

      def prepared_content
        html = prepared_html || ""

        return html unless prepared_render_block

        html + view_context.instance_exec(&prepared_render_block)
      end
  end
end
