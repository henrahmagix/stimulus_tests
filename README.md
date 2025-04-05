# StimulusTests

Test your Stimulus controllers in Rails!

This gem provides a route in test environments by which you can render any HTML with an importmap entry point, and assert on it with the usual browser finders and actions.

This supports the latest minor versions from Rails 6.1 to 8.0. See [Appraisals](/Appraisals).

## Installation
Add this line to your application's Gemfile:

```ruby
gem "stimulus_tests", group: :test
```

And then execute:
```shell
$ bundle
```

Or install it yourself as:
```shell
$ gem install stimulus_tests
```

## Usage

See also [Examples](#examples). All the code examples here reference the default Stimulus controller made by `bin/rails stimulus:install` named `hello`, which replaces the element's text with `"Hello World!"`

First, include the DSL and set an `import` in your test setup scope:
```rb
include StimulusTests::DSL

import "application"
```

Then call `render_stimulus` before your assertions. It can be called one of two ways:
```rb
# 1. With a HTML string.
render_stimulus '<p data-controller="hello">Initial text</p>'

# 2. With a block that gets evaluated in a View context where you can make use of tag helpers.
# The return value is used like the HTML string.
render_stimulus do
  content_tag :p, 'Initial text', data: { controller: "hello" }
end
```

Now you can assert on the browser page, like `assert_text "Hello World!" ✨

<br>

Under the hood, `render_stimulus` visits a route defined by this gem (see [Configuration](#configuration)), where the controller action renders `javascript_importmap_tags` with the given `import`, and then the HTML. This is how we get a test browser to load a page with just the JavaScript we need without having to commit such a page to your app.

You can also call `layout` to configure the layout of the controller defined by this gem:
```rb
include StimulusTests::DSL

layout "application"
```

Most of the time you won't need both `layout` and `import`: if you have a layout with your entry point already, you can use that and you don't need to use `import`.

Defining an `import` entry point and _not_ having a layout reduces the dependencies so you can more clearly unit-test your Stimulus controllers.

They can also be passed into `render_stimulus` to override the previous definitions:
```rb
render_stimulus(layout: "my_specific_layout", import: "controllers") do
  '<p data-controller="hello">Initial text</p>'
end
```

**Note:** if you specify both, and the layout already includes the importmap entry point, then it'll get added twice: this gem always renders the given import into the `<head>`.

### Configuration

```rb
# config/environments/test.rb
Rails.application.configure do
  config.stimulus_tests.route_path = "/_stimulus_tests" # this is the default
end
```

## Examples

### Rails tests

```rb
# test/system/hello_stimulus_controller_test.rb
require "application_system_test_case"
require "stimulus_tests"

class HelloStimulusControllerTest < ApplicationSystemTestCase
  include StimulusTests::DSL

  layout "application"
  # or
  # import "application"

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
  layout "application"
  # or
  # import "application"

  it "runs my controllers" do
    render_stimulus <<~HTML
      <p data-controller="hello">Initial text</p>
    HTML

    assert_text "Hello World!"
  end
end
```

You can setup any other example individually by ensuring the following:
- `StimulusTests::DSL` is included in the example group.
- Examples are run with a JavaScript driver.

## Contributing
Please do! Issues are 👆 up there, and feel free to submit pull-requests for your ideas.

I can't guarantee when I'll be able to read and respond, sorry.

### Setup

```sh
bin/appraisal install
```

### Tests

We have both Minitest and RSpec tests because this gem works with both frameworks.

This gem's tests are written in Minitest in the `test/` directory. The RSpec tests in `spec/` are only to test the integration of this gem with RSpec.

`bin/test` has been edited to run all tests by default, unless given specific paths.

```sh
bin/appraisal bin/test
```
```sh
bin/appraisal bin/rspec
```

To run all the tests together:
```sh
bin/appraisal bin/test && bin/appraisal bin/rspec
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
