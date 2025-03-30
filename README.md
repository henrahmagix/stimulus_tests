# StimulusTests

Test your Stimulus controllers in Rails!

This gem provides a route in test environments by which you can render any HTML with an importmap entry point, and assert on it with the usual browser finders and actions.

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

## Usage

There are three parts to this gem:
1. including the DSL,
2. setting a `layout` or `importmap_entry_point`, and
3. calling `render_stimulus` in your test

`render_stimulus` can be called one of two ways:
```rb
# 1. with a HTML string
render_stimulus '<p data-controller="hello">Initial text</p>'

# 2. with a block that gets evaluated in a View context; the return value is used like the HTML string
render_stimulus do
  content_tag :p, 'Initial text', data: { controller: "hello" }
end
```

The following examples use the default Stimulus controller made by `bin/rails stimulus:install` named `hello`, which replaces the element's text with `"Hello World!"`:
```js
// app/javascript/controllers/hello_controller.js
export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}
```

### Rails tests

```rb
# test/system/hello_stimulus_controller_test.rb
require "application_system_test_case"
require "stimulus_tests"

class HelloStimulusControllerTest < ApplicationSystemTestCase
  include StimulusTests::DSL

  layout "application"

  test "runs my controllers" do
    render_stimulus <<~HTML
      <p data-controller="hello">Initial text</p>
    HTML

    assert_text "Hello World!"
  end
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

RSpec.feature "Stimulus::HelloController" do
  importmap_entry_point "controllers"

  it "runs my controllers" do
    render_stimulus <<~HTML
      <p data-controller="hello">Initial text</p>
    HTML

    assert_text "Hello World!"
  end
end
```

You can setup any other example individually by ensuring the following:
- `include StimulusTests::DSL` is added to the example group.
- Examples are run with a JavaScript driver.

## Contributing
Please do! Issues are 👆 up there, and feel free to submit pull-requests for your ideas.

I can't guarantee when I'll be able to read and respond, sorry.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
