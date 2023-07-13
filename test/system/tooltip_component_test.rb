require "application_system_test_case"

class TooltipComponentSystemTest < ApplicationSystemTestCase
  def test_default
    with_preview("tooltip_component/default")

    assert_no_selector ".Polaris-Tooltip"

    find('[data-controller="polaris-tooltip"]').hover
    assert_selector ".Polaris-Tooltip"
  end
end
