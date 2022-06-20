require "test_helper"

class AutocompleteComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_basic_autocomplete
    render_inline(Polaris::AutocompleteComponent.new) do |autocomplete|
      autocomplete.text_field(label: "Tags")
      autocomplete.option(label: "Rustic", value: "rustic")
    end

    assert_selector '[data-controller="polaris-autocomplete"]' do
      assert_selector '[data-controller="polaris-popover"]' do
        assert_selector '[data-polaris-popover-target="activator"]' do
          assert_selector "label", text: "Tags"
          assert_selector ".Polaris-TextField"
        end
      end
    end
  end
end
