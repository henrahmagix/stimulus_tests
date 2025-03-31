module BrowserTestHelper
  def assert_application_layout
    assert_title "Dummy"
  end

  def assert_stimulus_layout
    assert_title "Stimulus Tests"
  end

  def print_console_errors_if_any
    console_errors = page.driver.browser.logs.get(:browser)
                        .reject { |log| log.message.match(/JQMIGRATE|preload/) }
                        .map { |log| "#{log.level}: #{log.message}" }
    puts "Console errors, in case they're help:\n#{console_errors.join("\n")}" if console_errors.present?
  end
end
