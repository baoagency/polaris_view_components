require "application_system_test_case"

class ToastComponentSystemTest < ApplicationSystemTestCase
  def test_basic_toast
    with_preview("toast_component/basic")

    assert_no_selector ".Polaris-Frame-Toast"

    click_on "Show toast"
    assert_selector ".Polaris-Frame-Toast", text: "Message sent"

    sleep 5
    assert_no_selector ".Polaris-Frame-Toast"
  end

  def test_multiple_toasts
    with_preview("toast_component/multiple")

    assert_no_selector ".Polaris-Frame-Toast"

    click_on "Show toast 1"
    click_on "Show toast 2"
    click_on "Show toast 3"

    assert_selector ".Polaris-Frame-Toast", text: "Message sent"
    assert_selector ".Polaris-Frame-Toast", text: "Image uploaded"
    assert_selector ".Polaris-Frame-Toast", text: "Third toast"
  end
end
