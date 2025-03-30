require "application_stimulus_test_case"

class StimulusHelloControllerWithoutAnythingTest < ApplicationStimulusTestCase
  test "visits the correct path" do
    visit_html("<p>Testing</p>")

    assert_equal "/_stimulus_tests", current_path
    assert_text "Testing"
  end

  test "does not run the stimulus controller" do
    visit_html do
      content_tag(:p, "Initial text", data: { controller: "hello" })
    end

    refute_application_layout

    refute_text "Hello World!"
    assert_text "Initial text"
  end
end

class StimulusHelloControllerWithoutLayoutButWithEntryPointTest < ApplicationStimulusTestCase
  importmap_entry_point "application"

  test "tests the Hello controller with HTML string in an empty layout but with the correct entry point" do
    visit_html("<p data-controller=hello>Initial text</p>")

    refute_application_layout

    assert_text "Hello World!"
  ensure
    print_console_errors_if_any
  end

  test "tests the Hello controller with content_tag in an empty layout but with the correct entry point" do
    visit_html do
      content_tag(:p, "Initial text", data: { controller: "hello" })
    end

    refute_application_layout

    assert_text "Hello World!"
  ensure
    print_console_errors_if_any
  end
end

class StimulusHelloControllerWithLayoutTest < ApplicationStimulusTestCase
  layout "application"

  test "tests the Hello controller in the application layout where the entry point is already set correctly" do
    visit_html do
      content_tag(:p, "Initial text", data: { controller: "hello" })
    end

    assert_application_layout

    assert_text "Hello World!"
  ensure
    print_console_errors_if_any
  end
end

class StimulusHelloControllerLayoutOverrideFromNilTest < ApplicationStimulusTestCase
  layout nil

  test "tests the Hello controller" do
    visit_html(layout: "application") do
      content_tag(:p, "Initial text", data: { controller: "hello" })
    end

    assert_application_layout

    assert_text "Hello World!"
  ensure
    print_console_errors_if_any
  end
end

class StimulusHelloControllerLayoutOverrideToNilTest < ApplicationStimulusTestCase
  layout "application"

  test "tests the Hello controller with entry point" do
    visit_html(layout: nil, importmap_entry_point: "application") do
      content_tag(:p, "Initial text", data: { controller: "hello" })
    end

    refute_application_layout

    assert_text "Hello World!"
  ensure
    print_console_errors_if_any
  end

  test "does not work without the entry point" do
    visit_html(layout: nil, importmap_entry_point: nil) do
      content_tag(:p, "Initial text", data: { controller: "hello" })
    end

    refute_application_layout

    refute_text "Hello World!"
    assert_text "Initial text"
  ensure
    print_console_errors_if_any
  end
end
