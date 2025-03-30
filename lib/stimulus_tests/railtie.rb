module StimulusTests
  class Railtie < ::Rails::Railtie
    if Rails.env.test?
      config.stimulus_tests = ActiveSupport::OrderedOptions.new
      config.stimulus_tests.route_path = "/_stimulus_tests"

      config.after_initialize do |app|
        route_path = config.stimulus_tests.route_path
        app.routes.prepend { get route_path => "stimulus_tests/visit#index" }
      end
    else
      def config.stimulus_tests=(*)
        raise NotImplementedError, "StimulusTests configuration is only available in test environment."
      end
    end
  end
end
