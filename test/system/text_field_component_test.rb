require "application_system_test_case"

class TextFieldComponentSystemTest < ApplicationSystemTestCase
  def test_number_field
    with_preview("text_field_component/number")

    assert_field "Quantity", with: "1.34"

    # Increase value
    find("#quantity").click
    find("[data-action='click->polaris-text-field#increase']").click
    assert_field "Quantity", with: "2.34"

    # Decrease value
    find("[data-action='click->polaris-text-field#decrease']").click
    assert_field "Quantity", with: "1.34"
  end

  def test_character_count
    with_preview("text_field_component/with_character_count")

    assert_field "Store name", with: "Jaded Pixel"
    assert_selector ".Polaris-TextField__CharacterCount", text: "11/20"

    fill_in "Store name", with: "Brand New Store Name"
    assert_selector ".Polaris-TextField__CharacterCount", text: "20/20"
  end

  def test_clear_button
    with_preview("text_field_component/with_clear_button")

    assert_field "Store name", with: "Jaded Pixel"

    find("#store_name").click
    find(".Polaris-TextField__ClearButton").click
    assert_field "Store name", with: ""
  end

  def test_clear_errors
    with_preview("text_field_component/clear_error_on_focus")

    find("#store_name").click

    assert_no_selector "Polaris-TextField--error"
    assert_no_selector "Polaris-Labelled__Error"
  end
end
