require "test_helper"

class StimulusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stimulus_index_url
    assert_response :success
  end
end
