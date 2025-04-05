if defined?(RSpec.configure)
  RSpec.configure do |config|
    private def match_folder(dir_parts)
      # This ensures a match on Windows and other systems.
      # See `infer_spec_type_from_file_location!` in rspec/rails/configuration.rb
      Regexp.compile(dir_parts.join('[\\\/]') + '[\\\/]')
    end

    JS_DIRECTORY_MAPPINGS = [
      match_folder(%w[spec stimulus]),
      match_folder(%w[spec features stimulus]),
      match_folder(%w[spec system stimulus])
    ].freeze

    JS_DIRECTORY_MAPPINGS.each do |file_path_match|
      config.define_derived_metadata(file_path: file_path_match) do |metadata|
        metadata[:js] = true # we always need a javascript driver
        metadata[:stimulus] = true
      end
    end

    config.include StimulusTests::DSL, :stimulus
  end
end
