require "test_helper"

class HeadingComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_heading
    render_inline(Polaris::HeadingComponent.new) { "Default" }

    assert_selector "h2.Polaris-Text--headingMd", text: "Default"
  end

  def test_renders_passed_element
    render_inline(Polaris::HeadingComponent.new(element: :p)) { "Default" }

    assert_selector "p", text: "Default"
  end
end
