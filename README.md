# StimulusTests

Test your Stimulus controllers in Rails!

## Usage

Given the default Stimulus controller made by `bin/rails stimulus:install`:

### Rails
```rb
require "stimulus_tests"

class HelloStimulusControllerTest < ApplicationSystemTestCase
  include StimulusTests::DSL

  layout nil
  importmap_entry_point "application"

  test "runs my controllers" do
    visit_html("<p data-controller=hello>Initial text</p>")

    assert_text "Hello World!"
  end
end
```

### RSpec

_todo!_

## Installation
Add this line to your application's Gemfile:

```ruby
gem "stimulus_tests"
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
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
