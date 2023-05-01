require "application_system_test_case"

class OptionListComponentSystemTest < ApplicationSystemTestCase
  def test_single_choice_option_list
    with_preview("option_list_component/single_choice")

    assert_no_selector ".Polaris-OptionList-Option--select"

    find("label", text: "Westboro").click
    assert_selector ".Polaris-OptionList-Option--select", text: "Westboro"

    find("label", text: "Centretown").click
    assert_no_selector ".Polaris-OptionList-Option--select", text: "Westboro"
    assert_selector ".Polaris-OptionList-Option--select", text: "Centretown"
  end

  def test_option_list_in_popover
    with_preview("option_list_component/in_popover")

    # Close popover
    find(".Polaris-Page").click
    assert_no_selector ".Polaris-Popover"

    # Open popover
    click_on "Options"
    within ".Polaris-Popover" do
      assert_text "Inventory Location"
      find("label", text: "Centretown").click
      assert_selector ".Polaris-OptionList-Option--select", text: "Centretown"
    end
  end
end
