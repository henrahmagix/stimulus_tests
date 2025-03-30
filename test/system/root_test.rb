require "application_system_test_case"

class RootTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit "/"

    assert_selector "h1", text: "Stimulus#index"
    assert_text "Hello World!"
  end
end
