require "rails_helper"

RSpec.feature "Stimulus::HelloController" do
  context "without any specific configuration" do
    it "visits the correct path" do
      render_stimulus("<p>Testing</p>")

      assert_equal "/_stimulus_tests", current_path
      assert_text "Testing"
    end

    it "does not run the stimulus controller" do
      render_stimulus do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      refute_application_layout

      assert_no_text "Hello World!"
      assert_text "Initial text"
    end
  end

  context "with importmap_entry_point and default layout" do
    importmap_entry_point "application"

    it "tests the Hello controller with HTML string in an empty layout but with the correct entry point" do
      render_stimulus("<p data-controller=hello>Initial text</p>")

      refute_application_layout

      assert_text "Hello World!"
    end

    it "tests the Hello controller with content_tag in an empty layout but with the correct entry point" do
      render_stimulus do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      refute_application_layout

      assert_text "Hello World!"
    end

    context "where entry point is controllers" do
      layout nil
      importmap_entry_point "controllers"

      it "tests the Hello controller with HTML string in an empty layout but with the correct entry point" do
        render_stimulus("<p data-controller=hello>Initial text</p>")

        refute_application_layout

        assert_text "Hello World!"
      end
    end
  end

  context "without specific layout and no importmap_entry_point (because the layout has it)" do
    layout "application"

    it "tests the Hello controller in the application layout where the entry point is already set correctly" do
      render_stimulus do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      assert_application_layout

      assert_text "Hello World!"
    end
  end

  context "with layout overridden from nil in each" do
    layout nil

    it "tests the Hello controller" do
      render_stimulus(layout: "application") do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      assert_application_layout

      assert_text "Hello World!"
    end
  end

  context "with layout overridden from specific in each" do
    layout "application"

    it "tests the Hello controller with entry point" do
      render_stimulus(layout: nil, importmap_entry_point: "application") do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      refute_application_layout

      assert_text "Hello World!"
    end

    it "does not work without the entry point because none of the js is loaded on the page" do
      render_stimulus(layout: nil, importmap_entry_point: nil) do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      refute_application_layout

      assert_no_text "Hello World!"
      assert_text "Initial text"
    end
  end
end
