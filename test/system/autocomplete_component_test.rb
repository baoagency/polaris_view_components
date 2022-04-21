require "application_system_test_case"

class AutocompleteComponentSystemTest < ApplicationSystemTestCase
  def test_basic_autocomplete
    with_preview("forms/autocomplete_component/basic")

    # Open autocomplete
    find(".Polaris-TextField__Input").click
    assert_selector ".Polaris-OptionList-Option", text: "Rustic"
    assert_selector ".Polaris-OptionList-Option", text: "Vintage"

    # Enter query
    find(".Polaris-TextField__Input").set "Vint"
    assert_no_selector ".Polaris-OptionList-Option", text: "Rustic"
    assert_selector ".Polaris-OptionList-Option", text: "Vintage"
  end

  def test_preselected_autocomplete
    with_preview("forms/autocomplete_component/preselected")

    # Open autocomplete
    find(".Polaris-TextField__Input").click
    assert_no_selector ".Polaris-OptionList-Checkbox__Input:checked[value=rustic]"
    assert_selector ".Polaris-OptionList-Checkbox__Input:checked[value=antique]"
    assert_selector ".Polaris-OptionList-Checkbox__Input:checked[value=vintage]"

    # Enter query
    find(".Polaris-TextField__Input").set "Vin"
    assert_no_selector ".Polaris-OptionList-Checkbox__Input:checked[value=vinyl]"
    assert_selector ".Polaris-OptionList-Checkbox__Input:checked[value=vintage]"
  end

  def test_remote_autocomplete
    with_preview("forms/autocomplete_component/remote")

    # Local default suggestions
    within all('[data-controller="polaris-autocomplete"]')[0] do
      assert_selector ".Polaris-Label", text: "Tags with local suggestions"

      # Check default suggestions
      find(".Polaris-TextField__Input").click
      assert_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"

      # Enter query
      find(".Polaris-TextField__Input").set "Vint"
      assert_no_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"
    end

    # Remote default suggestions
    within all('[data-controller="polaris-autocomplete"]')[1] do
      assert_selector ".Polaris-Label", text: "Tags with remote suggestions"

      # Check default suggestions
      find(".Polaris-TextField__Input").click
      assert_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"

      # Enter query
      find(".Polaris-TextField__Input").set "Vint"
      assert_no_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"
    end
  end

  def test_empty_state
    with_preview("forms/autocomplete_component/empty_state")

    find(".Polaris-TextField__Input").click
    find(".Polaris-TextField__Input").set "Unknown"
    assert_selector ".Polaris-Autocomplete__EmptyState", text: "Could not find any results"
  end

  def test_event_handler
    with_preview("forms/autocomplete_component/event_handler")

    # Open autocomplete
    find(".Polaris-TextField__Input").click
    assert_selector ".Polaris-OptionList-Option", text: "Rustic"

    # Select Vinyl
    accept_alert "Selected vinyl" do
      find(".Polaris-OptionList-Option", text: "Vinyl").click
    end
    assert_selector ".Polaris-OptionList-Option--select", text: "Vinyl"
  end
end
