require "application_system_test_case"

class PopoverComponentSystemTest < ApplicationSystemTestCase
  def close_popover
    find(".Polaris-Page").click
    assert_no_selector ".Polaris-Popover"
  end

  def open_popover
    click_on "More actions"
  end

  def test_default_popover
    with_preview("popover_component/with_action_list")

    close_popover
    open_popover

    within ".Polaris-Popover" do
      assert_selector ".Polaris-ActionList__Item", text: "Import"
      assert_selector ".Polaris-ActionList__Item", text: "Export"
    end
  end

  def test_custom_activator
    with_preview("popover_component/with_custom_activator")

    close_popover
    open_popover

    within ".Polaris-Popover" do
      assert_selector ".Polaris-ActionList__Item", text: "Import"
      assert_selector ".Polaris-ActionList__Item", text: "Export"
    end
  end

  def test_with_content_and_actions
    with_preview("popover_component/with_content_and_actions")

    close_popover
    open_popover

    within ".Polaris-Popover__Pane.Polaris-Popover__Pane--fixed" do
      assert_selector ".Polaris-Popover__Section", text: "Available sales channels"
    end

    within ".Polaris-Popover__Pane.Polaris-Scrollable.Polaris-Scrollable--vertical .Polaris-ActionList" do
      assert_selector ".Polaris-ActionList__Item", text: "Online store"
    end
  end

  def test_popover_appended_to_body
    with_preview("popover_component/appended_to_body")

    close_popover
    open_popover

    within ".Polaris-Popover" do
      assert_selector ".Polaris-ActionList__Item", text: "Import"
      assert_selector ".Polaris-ActionList__Item", text: "Export"
    end
  end
end
