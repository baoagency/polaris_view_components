require "application_system_test_case"

class FrameComponentSystemTest < ApplicationSystemTestCase
  setup do
    resize_screen_to(375, 667)
  end

  def test_mobile_menu
    with_preview("structure/frame_component/default")

    assert_no_selector ".Polaris-Navigation"

    # Open menu
    find(".Polaris-TopBar__NavigationIcon").click
    within ".Polaris-Navigation" do
      assert_selector ".Polaris-Navigation__Text", text: "JADED PIXEL APP"
    end

    # Close menu
    find(".Polaris-Frame__NavigationDismiss").click
    assert_no_selector ".Polaris-Navigation"
  end
end
