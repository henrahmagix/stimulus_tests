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

    class << self
      attr_reader :prepared, :configuration

      def _setup(configuration)
        @prepared = true
        @configuration = configuration
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
        return unless prepared_import

        insert_position = response.body.index("</head>") || 0
        js_import       = javascript_importmap_tags(prepared_import)

        response.body = response.body.insert(insert_position, js_import)
      end

      def prepared_layout       = self.class.configuration.layout || DEFAULT_LAYOUT
      def prepared_import       = self.class.configuration.import
      def prepared_render_block = self.class.configuration.render_block
      def prepared_html         = self.class.configuration.html

      def prepared_content
        html = prepared_html || ""

        return html unless prepared_render_block

        html + view_context.instance_exec(&prepared_render_block)
      end
  end
end
