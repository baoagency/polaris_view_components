require "test_helper"

class SubheadingComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_subheading
    render_inline(Polaris::SubheadingComponent.new) { "Default" }

    assert_selector "h3.Polaris-Text--headingXs", text: "Default"
  end
end
