require "test_helper"

class TextStyleComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default
    render_inline(Polaris::TextStyleComponent.new) { "Text" }

    assert_selector "span[class='']", text: "Text"
  end

  def test_subdued_style
    render_inline(Polaris::TextStyleComponent.new(variation: :subdued)) { "Text" }

    assert_selector "span.Polaris-TextStyle--variationSubdued", text: "Text"
  end

  def test_strong_style
    render_inline(Polaris::TextStyleComponent.new(variation: :strong)) { "Text" }

    assert_selector "span.Polaris-TextStyle--variationStrong", text: "Text"
  end

  def test_positive_style
    render_inline(Polaris::TextStyleComponent.new(variation: :positive)) { "Text" }

    assert_selector "span.Polaris-TextStyle--variationPositive", text: "Text"
  end

  def test_negative_style
    render_inline(Polaris::TextStyleComponent.new(variation: :negative)) { "Text" }

    assert_selector "span.Polaris-TextStyle--variationNegative", text: "Text"
  end

  def test_code_style
    render_inline(Polaris::TextStyleComponent.new(variation: :code)) { "Text" }

    assert_selector "span.Polaris-TextStyle--variationCode", text: "Text"
  end
end
