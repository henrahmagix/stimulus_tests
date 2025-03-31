module BrowserRSpecHelper
  extend RSpec::Matchers::DSL

  # When there's no <title> in the page, the `have_title` matcher fails since it tries to call `nil.match?`. Because of
  # that, we specifically assert on the element by its CSS selector.

  def assert_application_layout
    expect(page).to have_css("head title", visible: :all)
    expect(page).to have_title("Dummy")
  end

  def assert_stimulus_layout
    expect(page).to have_css("head title", visible: :all)
    expect(page).to have_title("Stimulus Tests")
  end

  def print_console_errors_if_any
    return unless page.driver.browser.respond_to?(:logs)

    console_errors = page.driver.browser.logs.get(:browser)
                        .reject { |log| log.message.match(/JQMIGRATE|preload/) }
                        .map { |log| "#{log.level}: #{log.message}" }
    puts "Console errors, in case they're help:\n#{console_errors.join("\n")}" if console_errors.present?
  end
end

RSpec.configure do |config|
  config.include BrowserRSpecHelper, type: :feature
  config.include BrowserRSpecHelper, type: :system

  print_console_errors_after = proc do |example|
    next unless example.exception

    print_console_errors_if_any
  end

  config.after(type: :feature, &print_console_errors_after)
  config.after(type: :system, &print_console_errors_after)
end
