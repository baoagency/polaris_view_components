require "application_system_test_case"

class PageComponentSystemTest < ApplicationSystemTestCase
  def test_action_group
    with_preview("page_component/with_all_header_elements")

    within ".Polaris-ActionMenu--desktop" do
      click_on "Promote"
    end

    within ".Polaris-Popover" do
      assert_text "Share on Facebook"
      assert_text "Share on Twitter"
    end
  end

  def test_action_menu_responsiveness
    with_preview("page_component/with_all_header_elements")

    within ".Polaris-ActionMenu--desktop" do
      assert_selector ".Polaris-ActionMenu-SecondaryAction", text: "Duplicate"
      assert_selector ".Polaris-ActionMenu-SecondaryAction", text: "Promote"
    end

    resize_screen_to :mobile

    assert_no_selector ".Polaris-ActionMenu--desktop"
    within ".Polaris-ActionMenu--mobile" do
      find(".Polaris-ActionMenu-RollupActions__RollupActivator").click
    end
    within ".Polaris-Popover" do
      assert_text "Duplicate"
      assert_text "Promote"
      assert_text "Share on Facebook"
      assert_text "Share on Twitter"
    end
  end

  def test_pagination_responsiveness
    with_preview("page_component/with_all_header_elements")

    assert_selector ".Polaris-Page-Header__PaginationWrapper"
    resize_screen_to :mobile
    assert_no_selector ".Polaris-Page-Header__PaginationWrapper"
  end
end
