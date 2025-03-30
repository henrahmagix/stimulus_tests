module StimulusTests
  class VisitController < ::ActionController::Base
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

    class VisitedOutsideStimulusTestError < ::StandardError; end

    def index
      unless self.class.prepared
        raise VisitedOutsideStimulusTestError, "The StimulusTests route #{request.path.inspect} was visited without being setup correctly. Please use `render_stimulus` e.g. `render_stimulus { content_tag(:p, 'Some text') }`"
      end

      view = ::ActionView::OutputBuffer.new

      view.safe_concat importmap_entry_point
      view.safe_concat render_block
      view.safe_concat self.class.preparation.html if self.class.preparation.html

      render layout: self.class.preparation.layout, html: view.html_safe
    end

    private

      def importmap_entry_point
        return "" unless self.class.preparation.importmap_entry_point

        view_context.javascript_importmap_tags(self.class.preparation.importmap_entry_point)
      end

      def render_block
        return "" unless self.class.preparation.render_block

        view_context.instance_exec(&self.class.preparation.render_block)
      end
  end
end
