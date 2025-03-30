require_relative "lib/stimulus_tests/version"

Gem::Specification.new do |spec|
  spec.name        = "stimulus_tests"
  spec.version     = StimulusTests::VERSION
  spec.authors     = [ "Henry Blyth" ]
  spec.email       = [ "blyth.henry@gmail.com" ]
  spec.homepage    = "https://github.com/henrahmagix/stimulus_tests"
  spec.summary     = "Test your Stimulus controllers in Rails!"
  spec.description = "Provides a route in test environments by which you can render any HTML with an importmap entry point and assert on it with the usual browser finders and actions."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/henrahmagix/stimulus_tests"
  spec.metadata["changelog_uri"] = "https://github.com/henrahmagix/stimulus_tests/releases"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.2"
end
