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
end
