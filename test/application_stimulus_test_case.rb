require "application_system_test_case"
require "stimulus_tests"

class ApplicationStimulusTestCase < ApplicationSystemTestCase
  include StimulusTests::DSL
end
