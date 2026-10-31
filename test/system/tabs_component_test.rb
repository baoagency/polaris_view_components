require "application_system_test_case"

class TabsComponentSystemTest < ApplicationSystemTestCase
  def test_selected_tab_scrolls_into_view
    with_preview("tabs_component/overflowing")

    assert_selector ".Polaris-LegacyTabs__Tab--selected", text: "Selected tab"
    assert page.evaluate_script(<<~JS)
      (() => {
        const list = document.querySelector(".Polaris-LegacyTabs").getBoundingClientRect()
        const tab = document.querySelector(".Polaris-LegacyTabs__Tab--selected").getBoundingClientRect()
        return tab.left >= list.left && tab.right <= list.right
      })()
    JS
  end
end
