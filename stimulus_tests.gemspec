require_relative "lib/stimulus_tests/version"

Gem::Specification.new do |spec|
  spec.name        = "stimulus_tests"
  spec.version     = StimulusTests::VERSION
  spec.authors     = [ "Henry Blyth" ]
  spec.email       = [ "blyth.henry@gmail.com" ]
  spec.homepage    = "https://example.com"
  spec.summary     = "Summary of StimulusTests."
  spec.description = "Description of StimulusTests."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://example.com"
  spec.metadata["changelog_uri"] = "https://example.com"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.2"
end
