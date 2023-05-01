require "test_helper"

class TextStyleComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default
    render_inline(Polaris::TextStyleComponent.new) { "Text" }

    assert_selector "span.Polaris-Text--regular", text: "Text"
  end

  def test_subdued_style
    render_inline(Polaris::TextStyleComponent.new(variation: :subdued)) { "Text" }

    assert_selector "span.Polaris-Text--subdued", text: "Text"
  end

  def test_strong_style
    render_inline(Polaris::TextStyleComponent.new(variation: :strong)) { "Text" }

    assert_selector "span.Polaris-Text--semibold", text: "Text"
  end

  def test_positive_style
    render_inline(Polaris::TextStyleComponent.new(variation: :positive)) { "Text" }

    assert_selector "span.Polaris-Text--success", text: "Text"
  end

  def test_negative_style
    render_inline(Polaris::TextStyleComponent.new(variation: :negative)) { "Text" }

    assert_selector "span.Polaris-Text--critical", text: "Text"
  end

  def test_code_style
    render_inline(Polaris::TextStyleComponent.new(variation: :code)) { "Text" }

    assert_selector "span.Polaris-Text--regular > code", text: "Text"
  end

  def test_small_size
    render_inline(Polaris::TextStyleComponent.new(size: :small)) { "Text" }

    assert_selector "span.Polaris-Text--bodySm", text: "Text"
  end
end
