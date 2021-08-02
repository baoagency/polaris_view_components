require "test_helper"

class HeadingComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_heading
    render_inline(Polaris::HeadingComponent.new) { "Default" }

    assert_selector "h2.Polaris-Heading", text: "Default"
  end

  def test_renders_passed_element
    p_element = "p"
    render_inline(Polaris::HeadingComponent.new(element: p_element)) { "Default" }

    assert_selector "#{p_element}.Polaris-Heading", text: "Default"

    h1_element = "h1"
    render_inline(Polaris::HeadingComponent.new(element: h1_element)) { "Default" }

    assert_selector "#{h1_element}.Polaris-Heading", text: "Default"

    h2_element = "h2"
    render_inline(Polaris::HeadingComponent.new(element: h2_element)) { "Default" }

    assert_selector "#{h2_element}.Polaris-Heading", text: "Default"
  end
end
