require "application_system_test_case"

class ButtonComponentSystemTest < ApplicationSystemTestCase
  def test_tertiary_destructive_color
    with_preview("button_component/tertiary_destructive")

    button = find_button("Remove")
    button.assert_matches_style(color: "rgb(212, 0, 4)")
    button.hover
    button.assert_matches_style(color: "rgb(184, 0, 4)", "background-color": "rgb(255, 231, 230)")
  end

  def test_disable_with_actions
    with_preview("button_component/disable_with_actions")

    assert_no_selector ".Polaris-Button--loading"

    # Disable
    click_on "Disable"
    assert_selector ".Polaris-Button--loading > .Polaris-Button__Spinner[role='status']"

    # Enable
    click_on "Enable"
    assert_no_selector ".Polaris-Button--loading"
    assert_no_selector ".Polaris-Button__Spinner"
  end

  def test_disable_with_loader
    with_preview("button_component/disable_with_loader")

    assert_no_selector ".Polaris-Button--loading"
    click_on "Disable on click"
    assert_selector ".Polaris-Button--loading > .Polaris-Button__Spinner[role='status']"
  end
end
