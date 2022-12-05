require "application_system_test_case"

class SelectComponentSystemTest < ApplicationSystemTestCase
  def test_default_select
    with_preview("select_component/default")

    within first(".Polaris-Select") do
      # Default option
      assert_selector ".Polaris-Select__Content", text: "Yesterday"

      # Select new option
      within "select#date_range", visible: false do
        find("option[value='today']").click
      end
      assert_selector ".Polaris-Select__Content", text: "Today"
    end
  end
end
