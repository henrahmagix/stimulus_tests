# StimulusTests

Test your Stimulus controllers in Rails!

This gem provides a route in test environments by which you can render any HTML with an importmap entry point, and assert on it with the usual browser finders and actions.

## Usage

Given the default Stimulus controller made by `bin/rails stimulus:install`:

### Rails

All that's needed is to include the DSL in your system test class. This can be done individually:
```rb
# test/system/hello_stimulus_controller_test.rb
require "application_system_test_case"
require "stimulus_tests"

class HelloStimulusControllerTest < ApplicationSystemTestCase
  include StimulusTests::DSL

  layout nil
  importmap_entry_point "application"

  test "runs my controllers" do
    render_stimulus("<p data-controller=hello>Initial text</p>")

    assert_text "Hello World!"
  end
end
```

Or you could define a root class for all your Stimulus tests:
```rb
# test/stimulus_test_case.rb
require "application_system_test_case"
require "stimulus_tests"

class StimulusTestCase < ApplicationSystemTestCase
  include StimulusTests::DSL
end
```

### RSpec

Require this gem in your Rails helper:
```rb
# spec/rails_helper.rb
require "stimulus_tests"
```

Every example in `spec/stimulus`, `spec/features/stimulus`, and `spec/system/stimulus` automatically gets the DSL included.

```rb
# spec/stimulus/hello_controller_spec.rb
require "rails_helper"

RSpec.feature "Stimulus::HelloControllers" do
  it "runs my controllers" do
    render_stimulus("<p data-controller=hello>Initial text</p>")

    assert_text "Hello World!"
  end
end
```

You can setup any other example individually by ensuring the following:
- `include StimulusTests::DSL` is added to the example group.
- Examples are run with a JavaScript driver.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "stimulus_tests", group: :test
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install stimulus_tests
```

## Contributing
Please do! Issues are 👆 up there, and feel free to submit pull-requests for your ideas.

I can't guarantee when I'll be able to read and respond, sorry.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
