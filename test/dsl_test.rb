require "test_helper"
require "minitest/mock"

class DSLInclusionTest < ActiveSupport::TestCase
  test "can't be included in non-test things" do
    assert_raises(
      StimulusTests::DSL::MissingTestFrameworkError,
      match: "StimulusTests::DSL cannot be included on Object: it expects a teardown method to be available."
    ) { Object.include StimulusTests::DSL }
  end

  test "calls teardown on the controller when test tears-down" do
    perform_teardown = Minitest::Mock.new
    perform_teardown.expect :call, nil
    StimulusTests::RenderController.stub :_teardown, perform_teardown do
      Class.new do
        def self.inspect = "#<#{self}:#{super}>"
        def self.to_s = "TeardownYieldingClass"
        def self.teardown(*); yield; end # yield immediately
        include StimulusTests::DSL
      end
    end
    assert perform_teardown.verify
  end

  test "calls teardown on the controller when test uses `after` instead of `teardown`" do
    perform_teardown = Minitest::Mock.new
    perform_teardown.expect :call, nil
    StimulusTests::RenderController.stub :_teardown, perform_teardown do
      Class.new do
        def self.inspect = "#<#{self}:#{super}>"
        def self.to_s = "AfterYieldingClass"
        def self.after(*); yield; end # yield immediately
        include StimulusTests::DSL
      end
    end
    assert perform_teardown.verify
  end
end

class DSLIntegratedTest < ActiveSupport::TestCase
  include StimulusTests::DSL

  teardown { Rails.application.reload_routes! }

  def visit(*); end

  test "raises error when route path isn't drawn" do
    # I can't find a way to *remove* a route that's already been defined so this setup becomes difficult. Thankfully a
    # broken controller route will raise an error, causing the DSL to not find a match, so that becomes our setup.
    Rails.application.routes.draw do
      get StimulusTests::Railtie.config.stimulus_tests.route_path => "unknown#whatever"
    end

    assert_raises(
      StimulusTests::DSL::MissingTestRouteError,
      match: "StimulusTests' route_path has not been drawn to Rails.application #<Dummy::Application"
    ) { render_stimulus }
  end

  test "raises error when route path goes elsewhere" do
    Rails.application.routes.draw do
      get StimulusTests::Railtie.config.stimulus_tests.route_path => "dummy#index"
    end

    assert_raises(
      StimulusTests::DSL::OverriddenTestRouteError,
      match: 'StimulusTests\' route_path has been overridden by matching a different route first: controller "dummy" should be "stimulus_tests/render".'
    ) { render_stimulus }
  end
end
