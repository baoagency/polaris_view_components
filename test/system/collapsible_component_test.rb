require "application_system_test_case"

class CollapsibleComponentSystemTest < ApplicationSystemTestCase
  def test_integration
    with_preview("collapsible_component/default")

    assert_no_text "Your mailing list lets you contact"
    click_on "Toggle"
    assert_text "Your mailing list lets you contact"
    click_on "Toggle"
    assert_no_text "Your mailing list lets you contact"
  end

  def test_title
    with_preview("collapsible_component/with_title")

    assert_no_text "Your mailing list lets you contact"
    assert_selector ".Polaris-Collapsible__Trigger[aria-expanded='false']"
    click_on "Advanced"
    assert_text "Your mailing list lets you contact"
    assert_selector ".Polaris-Collapsible__Trigger[aria-expanded='true']"
    click_on "Advanced"
    assert_no_text "Your mailing list lets you contact"
    assert_selector ".Polaris-Collapsible__Trigger[aria-expanded='false']"
  end
end
