require "test_helper"
require "webdrivers/geckodriver"

Capybara.server = :puma, {Silent: true}
Capybara.default_max_wait_time = 5
Capybara.default_set_options = {clear: :backspace}

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  DRIVER = ENV["HEADLESS"] == "false" ? :firefox : :headless_firefox
  SCREEN_SIZE = [1400, 1400].freeze

  driven_by :selenium, using: DRIVER, screen_size: SCREEN_SIZE

  teardown do
    resize_screen_to(*SCREEN_SIZE)
  end

  def resize_screen_to(width, height)
    Capybara.current_session.current_window.resize_to(width, height)
  end

  def with_preview(path)
    visit "/rails/view_components/#{path}"
    wait_for_javascript
  end

  def wait_for_javascript
    assert_selector "html.js"
  end
end
