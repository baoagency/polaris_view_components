require "application_system_test_case"

class PopoverComponentSystemTest < ApplicationSystemTestCase
  def test_default_popover
    with_preview("overlays/popover_component/with_action_list")

    # Close popover
    find(".Polaris-Page").click
    assert_no_selector ".Polaris-Popover"

    # Open popover
    click_on "More actions"
    within ".Polaris-Popover" do
      assert_selector ".Polaris-ActionList__Item", text: "Import"
      assert_selector ".Polaris-ActionList__Item", text: "Export"
    end
  end

  def test_custom_activator
    with_preview("overlays/popover_component/with_custom_activator")

    # Close popover
    find(".Polaris-Page").click
    assert_no_selector ".Polaris-Popover"

    # Open popover
    click_on "More actions"
    within ".Polaris-Popover" do
      assert_selector ".Polaris-ActionList__Item", text: "Import"
      assert_selector ".Polaris-ActionList__Item", text: "Export"
    end
  end
end
