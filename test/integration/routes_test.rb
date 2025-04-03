require "test_helper"

require "stimulus_tests"

class RoutesTest < ActionDispatch::IntegrationTest
  test "root" do
    assert_recognizes({ controller: "dummy", action: "index" }, "/")
  end

  test "StimulusTests::Railtie.config.stimulus_tests.route_path" do
    assert_recognizes({ controller: StimulusTests::RenderController.controller_path, action: "index" }, StimulusTests::Railtie.config.stimulus_tests.route_path)
  end
end
