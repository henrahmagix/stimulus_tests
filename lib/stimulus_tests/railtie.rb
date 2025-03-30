module StimulusTests
  class Railtie < ::Rails::Railtie
    config.stimulus_tests = ActiveSupport::OrderedOptions.new
    config.stimulus_tests.route_path = "/_stimulus_tests"

    config.after_initialize do |app|
      if Rails.env.test?
        route_path = config.stimulus_tests.route_path
        app.routes.prepend { get route_path => "stimulus_tests/visit#index" }
      else
        warn "StimulusTests is only available in the test environment."
      end
    end
  end
end
