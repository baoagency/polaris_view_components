require "application_system_test_case"

class AutocompleteComponentSystemTest < ApplicationSystemTestCase
  def test_basic_autocomplete
    with_preview("autocomplete_component/basic")

    # Open autocomplete
    find(".Polaris-TextField__Input").click
    assert_selector ".Polaris-OptionList-Option", text: "Rustic"
    assert_selector ".Polaris-OptionList-Option", text: "Vintage"

    # Enter query
    find(".Polaris-TextField__Input").set "Vint"
    assert_no_selector ".Polaris-OptionList-Option", text: "Rustic"
    assert_selector ".Polaris-OptionList-Option", text: "Vintage"

    # Autocomplete closes after selection
    find(".Polaris-OptionList-Option", text: "Vintage").click
    assert_no_selector ".Polaris-Popover"

    assert_field "tags", with: "Vintage"
  end

  def test_preselected_autocomplete
    with_preview("autocomplete_component/preselected")

    within first('[data-controller="polaris-autocomplete"]') do
      # Open autocomplete
      find(".Polaris-TextField__Input").click
      assert_no_selector ".Polaris-Checkbox__Input:checked[value=rustic]"
      assert_selector ".Polaris-Checkbox__Input:checked[value=antique]"
      assert_selector ".Polaris-Checkbox__Input:checked[value=vintage]"

      # Enter query
      find(".Polaris-TextField__Input").set "Vin"
      assert_no_selector ".Polaris-Checkbox__Input:checked[value=vinyl]"
      assert_selector ".Polaris-Checkbox__Input:checked[value=vintage]"
    end
  end

  def test_remote_autocomplete
    with_preview("autocomplete_component/remote")

    local_suggestions = all('[data-controller="polaris-autocomplete"]')[0]
    remote_suggestions = all('[data-controller="polaris-autocomplete"]')[1]
    opened_autocomplete = ".Polaris-Popover__PopoverOverlay--open"

    # Local default suggestions
    within local_suggestions do
      assert_selector ".Polaris-Label", text: "Tags with local suggestions"

      # Open local autocomplete
      find(".Polaris-TextField__Input").click
    end

    within opened_autocomplete do
      # Check default suggestions
      assert_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option__Label", text: "Vintage"
    end

    within local_suggestions do
      # Enter query
      find(".Polaris-TextField__Input").set "Vint"
    end

    within opened_autocomplete do
      assert_no_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"
    end

    # Remote default suggestions
    within remote_suggestions do
      assert_selector ".Polaris-Label", text: "Tags with remote suggestions"

      # Open remote autocomplete
      find(".Polaris-TextField__Input").click
    end

    within opened_autocomplete do
      # Check default suggestions
      assert_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"
    end

    within remote_suggestions do
      # Enter query
      find(".Polaris-TextField__Input").set "Vint"
    end

    within opened_autocomplete do
      assert_no_selector ".Polaris-OptionList-Option", text: "Rustic"
      assert_selector ".Polaris-OptionList-Option", text: "Vintage"
    end
  end

  def test_remote_autocomplete_opens_popover_for_empty_results
    with_preview("autocomplete_component/remote")

    remote_suggestions = all('[data-controller="polaris-autocomplete"]')[1]
    within remote_suggestions do
      find(".Polaris-TextField__Input").set "Unknown"
    end

    within ".Polaris-Popover__PopoverOverlay--open" do
      assert_selector ".Polaris-Autocomplete__EmptyState", text: "No matching suggestions found."
    end
  end

  def test_remote_autocomplete_ignores_out_of_order_responses
    with_preview("autocomplete_component/remote")

    page.execute_script <<~JAVASCRIPT
      window.fetch = (url) => {
        const query = new URL(url, window.location.origin).searchParams.get("q")
        const delay = query === "Slow" ? 800 : 50
        const results = `<li data-polaris-autocomplete-target="option" data-label="${query}">${query}</li>`

        return new Promise((resolve) => {
          setTimeout(() => resolve(new Response(results, {
            status: 200,
            headers: {"Content-Type": "text/html"}
          })), delay)
        })
      }
    JAVASCRIPT

    remote_suggestions = all('[data-controller="polaris-autocomplete"]')[1]
    within remote_suggestions do
      input = find(".Polaris-TextField__Input")
      input.set "Slow"
      sleep 0.3
      input.set "Fast"
    end

    assert_selector '[data-polaris-autocomplete-target="option"][data-label="Fast"]'
    sleep 0.7
    assert_selector '[data-polaris-autocomplete-target="option"][data-label="Fast"]'
    assert_no_selector '[data-polaris-autocomplete-target="option"][data-label="Slow"]'
  end

  def test_empty_state
    with_preview("autocomplete_component/empty_state")

    find(".Polaris-TextField__Input").click
    find(".Polaris-TextField__Input").set "Unknown"
    assert_selector ".Polaris-Autocomplete__EmptyState", text: "Could not find any results"
  end

  def test_event_handler
    with_preview("autocomplete_component/event_handler")

    # Open autocomplete
    find(".Polaris-TextField__Input").click
    assert_selector ".Polaris-OptionList-Option", text: "Rustic"

    # Select Vinyl
    accept_alert "Selected vinyl" do
      find(".Polaris-OptionList-Option", text: "Vinyl").click
    end
    assert_field "tags", with: "Vinyl"
  end
end
