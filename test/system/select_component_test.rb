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

  def test_grouped_select
    with_preview("select_component/grouped")

    within first(".Polaris-Select") do
      # Default option
      assert_selector ".Polaris-Select__Content", text: "Canada"

      # Select new option
      within "select#country", visible: false do
        find("option[value='US']").click
      end
      assert_selector ".Polaris-Select__Content", text: "United States"
    end
  end

  def test_time_zone_select
    with_preview("select_component/time_zone")

    within first(".Polaris-Select") do
      # Default option
      assert_selector ".Polaris-Select__Content", text: "Canada"

      # Select new option
      within "select#time_zone", visible: false do
        find("option[value='International Date Line West']").click
      end
      assert_selector ".Polaris-Select__Content", text: "(GMT-12:00) International Date Line West"
    end
  end
end
