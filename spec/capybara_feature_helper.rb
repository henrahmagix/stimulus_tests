RSpec.configure do |config|
  config.when_first_matching_example_defined(:js) do
    require 'capybara/rails'
    Capybara.javascript_driver = :selenium_chrome_headless
  end
end
