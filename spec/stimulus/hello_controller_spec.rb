require "rails_helper"

RSpec.feature "Stimulus::HelloControllers" do
  context "without any specific configuration" do
    it "visits the correct path" do
      visit_html("<p>Testing</p>")

      assert_equal "/_stimulus_tests", current_path
      assert_text "Testing"
    end

    it "does not run the stimulus controller" do
      visit_html do
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
      visit_html("<p data-controller=hello>Initial text</p>")

      refute_application_layout

      assert_text "Hello World!"
    end

    it "tests the Hello controller with content_tag in an empty layout but with the correct entry point" do
      visit_html do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      refute_application_layout

      assert_text "Hello World!"
    end
  end

  context "without specific layout and no importmap_entry_point (because the layout has it)" do
    layout "application"

    it "tests the Hello controller in the application layout where the entry point is already set correctly" do
      visit_html do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      assert_application_layout

      assert_text "Hello World!"
    end
  end

  context "with layout overridden from nil in each" do
    layout nil

    it "tests the Hello controller" do
      visit_html(layout: "application") do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      assert_application_layout

      assert_text "Hello World!"
    end
  end

  context "with layout overridden from specific in each" do
    layout "application"

    it "tests the Hello controller with entry point" do
      visit_html(layout: nil, importmap_entry_point: "application") do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      refute_application_layout

      assert_text "Hello World!"
    end

    it "does not work without the entry point because none of the js is loaded on the page" do
      visit_html(layout: nil, importmap_entry_point: nil) do
        content_tag(:p, "Initial text", data: { controller: "hello" })
      end

      refute_application_layout

      assert_no_text "Hello World!"
      assert_text "Initial text"
    end
  end
end
