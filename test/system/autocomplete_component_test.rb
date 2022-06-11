require "application_system_test_case"

class AutocompleteComponentSystemTest < ApplicationSystemTestCase
  def test_basic_autocomplete
    with_preview("forms/autocomplete_component/basic")

    open_autocomplete
    assert_selector ".Polaris-OptionList-Option", text: "Rustic"
    assert_selector ".Polaris-OptionList-Option", text: "Vintage"

    type_text "Vint"
    assert_no_selector ".Polaris-OptionList-Option", text: "Rustic"
    assert_selector ".Polaris-OptionList-Option", text: "Vintage"
  end

  def test_selecting_non_multiple
    with_preview("forms/autocomplete_component/basic")

    open_autocomplete
    type_text "Vint"
    find(".Polaris-OptionList-Option", text: "Vintage").click

    assert_field "Tags", with: "Vintage"
  end

  def test_selecting_multiple
    with_preview("forms/autocomplete_component/multiselect")

    open_autocomplete
    find(".Polaris-OptionList-Option", text: "Vintage").click
    find(".Polaris-OptionList-Option", text: "Rustic").click

    # assert_field 'Tags', with: 'Vintage,Rustic'
    assert_selector ".Polaris-OptionList-Checkbox__Input:checked[value=vintage]"
    assert_selector ".Polaris-OptionList-Checkbox__Input:checked[value=rustic]"
  end

  def test_preselected_autocomplete
    with_preview("forms/autocomplete_component/preselected")

    open_autocomplete
    assert_no_selector ".Polaris-OptionList-Checkbox__Input:checked[value=rustic]"
    assert_selector ".Polaris-OptionList-Checkbox__Input:checked[value=antique]"
    assert_selector ".Polaris-OptionList-Checkbox__Input:checked[value=vintage]"

    type_text "Vin"
    assert_no_selector ".Polaris-OptionList-Checkbox__Input:checked[value=vinyl]"
    assert_selector ".Polaris-OptionList-Checkbox__Input:checked[value=vintage]"
  end

  def test_remote_autocomplete
    with_preview("forms/autocomplete_component/remote")

    # Local default suggestions
    within all('[data-controller="polaris-autocomplete"]')[0] do
      assert_selector ".Polaris-Label", text: "Tags with local suggestions"

      # Check default suggestions
      open_autocomplete
      assert_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"

      type_text "Vint"
      assert_no_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"
    end

    # Remote default suggestions
    within all('[data-controller="polaris-autocomplete"]')[1] do
      assert_selector ".Polaris-Label", text: "Tags with remote suggestions"

      # Check default suggestions
      open_autocomplete
      assert_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"

      type_text "Vint"
      assert_no_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"
    end
  end

  def test_empty_state
    with_preview("forms/autocomplete_component/empty_state")

    open_autocomplete
    type_text "Unknown"
    assert_selector ".Polaris-Autocomplete__EmptyState", text: "Could not find any results"
  end

  def test_event_handler
    with_preview("forms/autocomplete_component/event_handler")

    open_autocomplete
    assert_selector ".Polaris-OptionList-Option", text: "Rustic"

    # Select Vinyl
    accept_alert "Selected vinyl" do
      find(".Polaris-OptionList-Option", text: "Vinyl").click
    end
  end

  private

  def autocomplete_input_field = find(".Polaris-TextField__Input")
  def open_autocomplete = autocomplete_input_field.click
  def type_text(text) = autocomplete_input_field.set(text)
end
