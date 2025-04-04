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
