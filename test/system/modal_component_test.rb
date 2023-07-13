require "application_system_test_case"

class ModalComponentSystemTest < ApplicationSystemTestCase
  def test_basic_modal
    with_preview("modal_component/basic")

    # Close modal
    find(".Polaris-Modal-CloseButton").click
    assert_no_selector ".Polaris-Modal-Dialog"

    # Open modal
    click_on "Open"
    within ".Polaris-Modal-Dialog" do
      assert_text "Reach more shoppers"
      assert_selector ".Polaris-Modal-Section", text: "Use Instagram posts to share your products"
      assert_selector ".Polaris-Button", text: "Add instagram"
    end
  end

  def test_custom_close_button
    with_preview("modal_component/custom_close_button")

    assert_selector ".Polaris-Modal-Dialog"
    accept_alert "Close modal" do
      find(".Polaris-Modal-CloseButton").click
    end
    assert_selector ".Polaris-Modal-Dialog"
  end
end
