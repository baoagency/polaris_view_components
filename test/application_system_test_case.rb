require "test_helper"
require "webdrivers/geckodriver"

Capybara.server = :puma, {Silent: true}
Capybara.default_max_wait_time = 5
Capybara.default_set_options = {clear: :backspace}

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  DRIVER = (ENV["HEADLESS"] == "false") ? :firefox : :headless_firefox
  DESKTOP_SCREEN_SIZE = [1400, 1400].freeze
  MOBILE_SCREEN_SIZE = [375, 667].freeze

  driven_by :selenium, using: DRIVER, screen_size: DESKTOP_SCREEN_SIZE

  teardown do
    resize_screen_to :desktop
  end

  def resize_screen_to(screen)
    screen_size = (screen == :desktop) ? DESKTOP_SCREEN_SIZE : MOBILE_SCREEN_SIZE
    Capybara.current_session.current_window.resize_to(*screen_size)
  end

  def with_preview(path)
    visit "/rails/view_components/#{path}"
    wait_for_javascript
  end

  def wait_for_javascript
    assert_selector "html.js"
  end
end
