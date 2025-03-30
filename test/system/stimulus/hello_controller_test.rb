require "application_stimulus_test_case"

class StimulusHelloControllerWithoutAnythingTest < ApplicationStimulusTestCase
  test "visits the correct path" do
    render_stimulus("<p>Testing</p>")

    assert_equal "/_stimulus_tests", current_path
    assert_text "Testing"
  end

  test "does not run the stimulus controller" do
    render_stimulus do
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
    render_stimulus("<p data-controller=hello>Initial text</p>")

    refute_application_layout

    assert_text "Hello World!"
  ensure
    print_console_errors_if_any
  end

  test "tests the Hello controller with content_tag in an empty layout but with the correct entry point" do
    render_stimulus do
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
    render_stimulus do
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
    render_stimulus(layout: "application") do
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
    render_stimulus(layout: nil, importmap_entry_point: "application") do
      content_tag(:p, "Initial text", data: { controller: "hello" })
    end

    refute_application_layout

    assert_text "Hello World!"
  ensure
    print_console_errors_if_any
  end

  test "does not work without the entry point" do
    render_stimulus(layout: nil, importmap_entry_point: nil) do
      content_tag(:p, "Initial text", data: { controller: "hello" })
    end

    refute_application_layout

    refute_text "Hello World!"
    assert_text "Initial text"
  ensure
    print_console_errors_if_any
  end
end
