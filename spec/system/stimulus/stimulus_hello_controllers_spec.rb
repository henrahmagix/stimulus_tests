require 'rails_helper'

RSpec.describe "Stimulus::HelloController" do
  before { driven_by(:selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]) }

  scenario "visiting the root" do
    visit "/"

    assert_selector "h1", text: "Stimulus#index"
    assert_text "Hello World!"
  end

  feature "using rack_test driver" do
    before { driven_by(:rack_test) }

    scenario "visiting the root does not load the stimulus controller" do
      visit "/"

      assert_selector "h1", text: "Stimulus#index"
      assert_text "This is the initial text"
    end
  end
end
