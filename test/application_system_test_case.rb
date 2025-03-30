require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  private

    def assert_application_layout
      assert_title "Dummy"
    end

    def refute_application_layout
      refute_title "Dummy"
    end

    def print_console_errors_if_any
      console_errors = page.driver.browser.logs.get(:browser)
                          .reject { |log| log.message.match(/JQMIGRATE|preload/) }
                          .map { |log| "#{log.level}: #{log.message}" }
      puts "Console errors, in case they're help:\n#{console_errors.join("\n")}" if console_errors.present?
    end
end
