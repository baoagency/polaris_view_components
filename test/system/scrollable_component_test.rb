require "application_system_test_case"

class ScrollableComponentSystemTest < ApplicationSystemTestCase
  def test_scrollable_shadows
    with_preview("scrollable_component/with_shadows")

    assert_selector ".Polaris-Scrollable.Polaris-Scrollable--hasBottomShadow"

    # Scroll to bottom
    scroll_to find('[data-polaris-scrollable-target="bottomEdge"]', visible: false)
    assert_no_selector ".Polaris-Scrollable.Polaris-Scrollable--hasBottomShadow"
    assert_selector ".Polaris-Scrollable.Polaris-Scrollable--hasTopShadow"

    # Scroll to top
    scroll_to find('[data-polaris-scrollable-target="topEdge"]', visible: false)
    assert_selector ".Polaris-Scrollable.Polaris-Scrollable--hasBottomShadow"
    assert_no_selector ".Polaris-Scrollable.Polaris-Scrollable--hasTopShadow"
  end
end
