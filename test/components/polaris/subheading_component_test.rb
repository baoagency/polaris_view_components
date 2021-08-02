require "test_helper"

class SubheadingComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_subheading
    render_inline(Polaris::SubheadingComponent.new) { "Default" }

    assert_selector "h3.Polaris-Subheading", text: "Default"
  end

  def test_custom_element
    render_inline(Polaris::SubheadingComponent.new(element: :h6)) { "Default" }

    assert_selector "h6.Polaris-Subheading", text: "Default"
  end
end
