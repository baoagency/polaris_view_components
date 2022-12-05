require "application_system_test_case"

class ButtonComponentSystemTest < ApplicationSystemTestCase
  def test_disable_with_actions
    with_preview("button_component/disable_with_actions")

    assert_no_selector ".Polaris-Button--loading"

    # Disable
    click_on "Disable"
    assert_selector ".Polaris-Button--loading > .Polaris-Button__Content > .Polaris-Button__Spinner"

    # Enable
    click_on "Enable"
    assert_no_selector ".Polaris-Button--loading"
  end

  def test_disable_with_loader
    with_preview("button_component/disable_with_loader")

    assert_no_selector ".Polaris-Button--loading"
    click_on "Disable on click"
    assert_selector ".Polaris-Button--loading > .Polaris-Button__Content > .Polaris-Button__Spinner"
  end
end
