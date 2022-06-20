require "application_system_test_case"

class FiltersComponentSystemTest < ApplicationSystemTestCase
  def test_with_resource_list
    with_preview("lists_and_tables/filters_component/with_resource_list")

    # Open filter
    click_on "Account status"

    within ".Polaris-Popover" do
      assert_selector ".Polaris-OptionList-Option", text: "Enabled"
    end
  end
end
