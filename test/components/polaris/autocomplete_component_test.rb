require "test_helper"

class AutocompleteComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_basic_autocomplete
    render_inline(Polaris::AutocompleteComponent.new) do |autocomplete|
      autocomplete.with_text_field(label: "Tags")
      autocomplete.with_option(label: "Rustic", value: "rustic")
    end

    assert_selector '[data-controller="polaris-autocomplete"]' do
      assert_selector '[data-controller="polaris-popover"]' do
        assert_selector '[data-polaris-popover-target="activator"]' do
          assert_selector "label", text: "Tags"
          assert_selector ".Polaris-TextField"
        end

        assert_selector ".Polaris-Popover" do
          assert_selector "input[type='radio'][value='rustic']"
        end
      end
    end
  end

  def test_multiple_autocomplete
    render_inline(Polaris::AutocompleteComponent.new(multiple: true)) do |autocomplete|
      autocomplete.with_text_field(label: "Tags")
      autocomplete.with_option(label: "Rustic", value: "rustic")
    end

    assert_selector ".Polaris-Popover" do
      assert_selector "input[type='checkbox'][value='rustic']"
    end
  end
end
